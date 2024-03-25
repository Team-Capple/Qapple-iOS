//
//  AuthViewModel.swift
//  Capple
//
//  Created by kyungsoolee on 3/9/24.
//

import Foundation
import AuthenticationServices

class AuthViewModel: ObservableObject {
    
    @Published var isSignIn = false // 로그인 되었는지 확인
    @Published var isSignUp = false // 회원가입 로직 실행용
    
    @Published var isSignInLoading = false // 로그인 로딩 용도
    
    @Published var authorizationCode: String = "" // 로그인 인증 코드
    @Published var nickname: String = "" // 닉네임
    @Published var email: String = "" // 이메일
    @Published var certifyCode: String = "" // 이메일 인증 코드
    
    @Published var isCertifyCodeVerified = false // 인증 코드 인증 완료 여부
    @Published var isCertifyCodeInvalid = false // 인증 코드 유효성 여부
    @Published var isCertifyCodeFailed = false // 인증 코드 실패 여부
    
    @Published var isNicknameFieldAvailable = true // 닉네임 유효성 검사
    
    @Published var isSignUpFailedAlertPresented = false // 회원가입 실패 알림
}

// MARK: - Helper
extension AuthViewModel {
    
    /// 모든 로그인/회원가입 정보를 초기화합니다.
    func resetAllInfo() {
        nickname.removeAll()
        email.removeAll()
        resetAuthCodeInfo()
    }
    
    /// 인증코드 정보를 초기화합니다.
    func resetAuthCodeInfo() {
        certifyCode.removeAll()
        isCertifyCodeVerified = false
        isCertifyCodeInvalid = false
        isCertifyCodeFailed = false
    }
    
    /// 특수 기호 체크 메서드
    /// 출처 : https://arc.net/l/quote/ojvfrfrb
    func koreaLangCheck(_ input: String) {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: input.utf16.count)
            if regex.firstMatch(in: input, options: [], range: range) != nil {
                isNicknameFieldAvailable = true
                return
            }
        }
        isNicknameFieldAvailable = false
    }
}

// MARK: - 로그인 & 회원가입
extension AuthViewModel {
    
    // Apple 로그인 요청 처리
    func appleLogin(request: ASAuthorizationAppleIDRequest) async {
        // Apple 로그인 요청을 처리하는 코드
        request.requestedScopes = [.fullName, .email]
    }
    
    // Apple 로그인 완료 처리
    @MainActor
    func appleLoginCompletion(result: Result<ASAuthorization, Error>) async {
        // Apple 로그인 완료 후 처리하는 코드
        switch result {
        case .success(let authResults):
            // print("Apple Login Successful")
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? "인증 코드 생성 실패"
                
                DispatchQueue.main.async {
                    // print("AuthorizationCode: \(authorizationCode)")
                }
                
                Task {
                    do {
                        let signInResponse = try await NetworkManager.requestSignIn(request: .init(code: authorizationCode))
                        SignInInfo.shared.updateAccessToken(signInResponse.accessToken ?? "")
                        SignInInfo.shared.updateRefreshToken(signInResponse.refreshToken ?? "")
                        
                        // 로그인 상태에 따른 화면 분기처리
                        if signInResponse.isMember {
                            isSignIn = true
                        } else {
                            isSignUp = true
                            // TODO: 회원가입 관련 변수 초기화
                            resetAllInfo()
                        }
                        isSignInLoading = false
                    } catch {
                        print("로그인 요칭 실패,,,")
                        isSignInLoading = false
                        // TODO: 로그인 실패 Alert
                    }
                    
                    // print("액세스 토큰 값!\n\(SignInInfo.shared.accessToken())\n")
                }
                
            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
            isSignInLoading = false
        }
    }
    
    /// 회원가입을 요청합니다.
    @MainActor
    func requestSignUp() async {
        do {
            // 회원가입 API
            let signUpData = try await NetworkManager.requestSignUp(
                request: .init(
                    signUpToken: SignInInfo.shared.refreshToken(),
                    email: "\(email)@postech.ac.kr",
                    nickname: nickname,
                    profileImage: ""))
            
            // 토큰 데이터 업데이트
            SignInInfo.shared.updateAccessToken(signUpData.accessToken ?? "")
            SignInInfo.shared.updateRefreshToken(signUpData.refreshToken ?? "")
        } catch {
            isSignUpFailedAlertPresented.toggle()
        }
    }
}

// MARK: - 대학 이메일 인증
extension AuthViewModel {
    
    /// 대학 이메일 인증을 요청합니다.
    @MainActor
    func requestEmailCertification() {
        Task {
            do {
                let _ = try await NetworkManager.requestUniversityMailAuth(
                    request: .init(
                        key: APIKey.univcertKey,
                        email: "\(email)@postech.ac.kr"))
            } catch {
                requestClearEmail()
            }
            
            // 인증 코드 초기화
            certifyCode.removeAll()
        }
    }
    
    /// 대학 이메일 인증 코드를 확인합니다.
    @MainActor
    func requestCertifyCode() {
        Task {
            do {
                let response = try await NetworkManager.requestUniversityCertifyCode(
                    request: .init(
                        key: APIKey.univcertKey,
                        email: "\(email)@postech.ac.kr",
                        code: Int(certifyCode) ?? 0
                    )
                )
                
                // 인증 성공 케이스
                if response.success {
                    isCertifyCodeVerified = true
                }
                
            } catch {
                // 인증 실패 케이스
                isCertifyCodeInvalid = true
                isCertifyCodeFailed = true
            }
        }
    }
    
    /// 대학 이메일 인증을 초기화합니다.
    @MainActor
    func requestClearEmail() {
        Task {
            do {
                let _ = try await NetworkManager.requestClearEmailUniversity(
                    request: .init(key: APIKey.univcertKey),
                    email: email)
                requestEmailCertification()
            } catch {
                print("대학 메일 인증 초기화에 실패했습니다.")
            }
        }
    }
}
