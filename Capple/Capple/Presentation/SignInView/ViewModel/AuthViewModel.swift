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
    @Published var authorizationCode: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    
    var signInResponse: MemberResponse.SignIn = .init(accessToken: nil, refreshToken: nil, isMember: false)
}

// MARK: - 애플 로그인
extension AuthViewModel {
    
    // Apple 로그인 요청 처리
    func appleLogin(request: ASAuthorizationAppleIDRequest) async {
        // Apple 로그인 요청을 처리하는 코드
        request.requestedScopes = [.fullName, .email]
    }
    
    // Apple 로그인 완료 처리
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
                
                // 로그인 요청
                Task {
                    let signInResponse = try await NetworkManager.requestSignIn(request: .init(code: authorizationCode))
                    self.signInResponse = signInResponse
                    print(signInResponse)
                }
                
            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
        }
    }
}

// MARK: - 이메일 인증
extension AuthViewModel {
    
    /// 대학 이메일 인증을 요청합니다.
    func requestEmailCertification() {
        Task {
            try await NetworkManager.requestUniversityMailAuth(request: .init(key: APIKey.univcertKey, email: "\(email)@postech.ac.kr"))
        }
    }
}
