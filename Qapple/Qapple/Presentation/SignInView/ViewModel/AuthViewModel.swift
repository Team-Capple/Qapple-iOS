//
//  AuthViewModel.swift
//  Capple
//
//  Created by kyungsoolee on 3/9/24.
//

import Foundation
import AuthenticationServices

class AuthViewModel: ObservableObject {
    
    let academyEmailAddress = "@pos.idserve.net"
    let testEmail = "testQapple"
    
    private var userID = ""
    
    @Published var isAutoSignInMode = true // 자동 로그인 모드 활성화
    
    @Published var isSignIn = false // 로그인 되었는지 확인
    @Published var isSignUp = false // 회원가입 로직 실행용
    
    @Published var isSignInLoading = false // 로그인 로딩 용도
    @Published var isLoading = false // 전체 로딩 관리
    
    @Published var authorizationCode: String = "" // 로그인 인증 코드
    @Published var nickname: String = "" // 닉네임
    @Published var email: String = "" // 이메일
    @Published var certifyCode: String = "" // 이메일 인증 코드
    @Published var certifyMailLoading = false // 이메일 발송 로딩
    @Published var isExistEmailAlertPresented = false // 이미 존재하는 이메일(가입된 이메일) 여부
    
    @Published var isCertifyCodeVerified = false // 인증 코드 인증 완료 여부
    @Published var isCertifyCodeInvalid = false // 인증 코드 유효성 여부
    @Published var isCertifyCodeFailed = false // 인증 코드 실패 여부
    
    @Published var isNicknameFieldAvailable = true // 닉네임 유효성 검사
    @Published var isNicknameCanUse = false // 닉네임 중복 검사
    
    @Published var isSignUpFailedAlertPresented = false // 회원가입 실패 알림
    
    @Published var isAppleLoginFailedAlertPresenteed = false // 애플 로그인 실패 알림
    @Published var isSignInFailedAlertPresented = false // 서버 로그인 실패 알림
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
        isNicknameFieldAvailable = true
        isNicknameCanUse = false
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

// MARK: - 닉네임
extension AuthViewModel {
    
    @MainActor
    func requestNicknameCheck() async {
        do {
            let check = try await NetworkManager.requestNicknameCheck(nickname)
            self.isNicknameCanUse = !check
        } catch {
            print("닉네임 중복 검사에 실패했습니다. 다시 시도해주세요")
        }
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
        switch result {
        case .success(let authResults):
            
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let authorizationCode = String(
                    data: appleIDCredential.authorizationCode!,
                    encoding: .utf8
                ) ?? "인증 코드 생성 실패"
                
                Task {
                    do {
                        let signInResponse = try await NetworkManager.requestSignIn(
                            request: .init(
                                code: authorizationCode,
                                deviceToken: SignInInfo.shared.deviceToken
                            )
                        )
                        try SignInInfo.shared.createToken(.access, token: signInResponse.accessToken ?? "")
                        try SignInInfo.shared.createToken(.refresh, token: signInResponse.refreshToken ?? "")
                        userID = appleIDCredential.user
                        
                        // 로그인 상태에 따른 화면 분기처리
                        if signInResponse.isMember {
                            isSignIn = true
                            try SignInInfo.shared.createUserID(userID)
                            print("로그인 고고")
                        } else {
                            isSignUp = true
                            print("회원가입 고고")
                            resetAllInfo()
                        }
                        isSignInLoading = false
                    } catch {
                        isSignInFailedAlertPresented = true
                        isSignInLoading = false
                    }
                }
                
            default: break
            }
        case .failure:
            isAppleLoginFailedAlertPresenteed = true
            isSignInLoading = false
        }
    }
    
    /// 회원가입을 요청합니다.
    @MainActor
    func requestSignUp() async {
        
        self.isLoading = true
        
        do {
            // 회원가입 API
            let signUpData = try await NetworkManager.requestSignUp(
                request: .init(
                    signUpToken: try SignInInfo.shared.token(.refresh),
                    email: "\(email)\(academyEmailAddress)",
                    nickname: nickname,
                    profileImage: "",
                    deviceToken: SignInInfo.shared.deviceToken
                )
            )
            
            // 토큰 데이터 업데이트
            try SignInInfo.shared.createToken(.access, token: signUpData.accessToken ?? "")
            try SignInInfo.shared.createToken(.refresh, token: signUpData.refreshToken ?? "")
            try SignInInfo.shared.createUserID(userID)
            print("UserID!\n\(try SignInInfo.shared.userID())\n")
            
            self.isLoading = false
        } catch {
            self.isLoading = false
            isSignUpFailedAlertPresented.toggle()
        }
    }
}

// MARK: - 대학 이메일 인증
extension AuthViewModel {
    
    /// 대학 이메일 인증을 요청합니다.
    @MainActor
    func requestEmailCertification() async -> Bool {
        
        self.isLoading = true
        
        // 인증 코드 초기화
        certifyCode.removeAll()
        
        do {
            let _ = try await NetworkManager.requestEmailCertificationCode(
                request: .init(
                    signUpToken: try SignInInfo.shared.token(.refresh),
                    email: "\(email)\(academyEmailAddress)"
                )
            )
            print("인증코드 전송 완료")
            self.isLoading = false
            return true
        } catch {
            print("인증코드 요청 실패")
            certifyMailLoading = false
            isExistEmailAlertPresented = true
            self.isLoading = false
            return false
        }
    }
    
    /// 대학 이메일 인증 코드를 확인합니다.
    @MainActor
    func requestCertifyCode() {
        
        self.isLoading = true
        
        Task {
            do {
                let response = try await NetworkManager.requestCodeCertificationCode(
                    request: .init(
                        signUpToken: try SignInInfo.shared.token(.refresh),
                        email: "\(email)\(academyEmailAddress)",
                        certCode: certifyCode
                    )
                )
                
                print("인증 코드 발송 완료")
                
                // 인증 성공 케이스
                if response {
                    print("인증 성공")
                    isCertifyCodeVerified = true
                }
                
                self.isLoading = false
                
            } catch {
                // 인증 실패 케이스
                print("인증 실패")
                isCertifyCodeInvalid = true
                isCertifyCodeFailed = true
                self.isLoading = false
            }
        }
    }
}
