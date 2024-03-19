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
    
    @Published var authorizationCode: String = "" // 로그인 인증 코드
    @Published var nickname: String = "" // 닉네임
    @Published var email: String = "" // 이메일
    @Published var certifyCode: String = "" // 이메일 인증 코드

    @Published var isMailResend = false // 메일 재발송 여부
    
    @Published var isCertifyCodeVerified = false // 인증 코드 인증 완료 여부
    @Published var isCertifyCodeInvalid = false // 인증 코드 유효성 여부
    @Published var isCertifyCodeFailed = false // 인증 코드 실패 여부
}

// MARK: - Helper
extension AuthViewModel {
    
    /// 모든 로그인/회원가입 정보를 초기화합니다.
    func resetAllInfo() {
        authorizationCode.removeAll()
        nickname.removeAll()
        email.removeAll()
        certifyCode.removeAll()
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
            print("Apple Login Successful")
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                // let userIdentifier = appleIDCredential.user
                // let fullName = appleIDCredential.fullName
                // let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                // let email = appleIDCredential.email
                // let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? "인증 코드 생성 실패"
                
                DispatchQueue.main.async { /*[weak self] in*/
                    // print("Name: \(name)")
                    // print("Email: \(email)")
                    // print("IdentityToken: \(identityToken)")
                    print("AuthorizationCode: \(authorizationCode)")
                }
                
                Task {
                    do {
                        let signInResponse = try await NetworkManager.requestSignIn(request: .init(code: authorizationCode))
                        SignInInfo.shared.updateAccessToken(signInResponse.accessToken ?? "")
                        SignInInfo.shared.updateRefreshToken(signInResponse.refreshToken ?? "")
                        
                        // 로그인 상태에 따른 화면 분기처리
                        if signInResponse.isMember {
                            print("뭐야 너 멤버잖아? 홈 화면으로 이동시켜주마")
                            isSignIn = true
                        } else {
                            print("아직 멤버가 아니군! 회원가입 필요")
                            isSignUp = true
                        }
                        
                    } catch {
                        print("로그인 요칭 실패,,,")
                    }
                    
                    print("\n액세스 토큰 값!\n\(SignInInfo.shared.accessToken())\n")
                }
                
            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
        }
    }
    
    /// 회원가입을 요청합니다.
    @MainActor
    func requestSignUp() {
        Task {
            let signUpData = try await NetworkManager.requestSignUp(
                request: .init(
                    signUpToken: SignInInfo.shared.refreshToken(),
                    nickname: nickname,
                    profileImage: ""
                )
            )
            
            // 토큰 데이터 업데이트
            SignInInfo.shared.updateAccessToken(signUpData.accessToken ?? "")
            SignInInfo.shared.updateRefreshToken(signUpData.refreshToken ?? "")
        }
    }
}

// MARK: - 대학 이메일 인증
extension AuthViewModel {
    
    /// 대학 이메일 인증을 요청합니다.
    @MainActor
    func requestEmailCertification() {
        Task {
            let _ = try await NetworkManager.requestUniversityMailAuth(
                request: .init(
                    key: APIKey.univcertKey,
                    email: "\(email)@postech.ac.kr"
                )
            )
            
            // 인증 코드 초기화
            certifyCode.removeAll()
            
            if isCertifyCodeFailed {
                isMailResend = true
            }
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
}
