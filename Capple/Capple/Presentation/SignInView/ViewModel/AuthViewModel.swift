//
//  AuthViewModel.swift
//  Capple
//
//  Created by kyungsoolee on 3/9/24.
//

import Foundation
import AuthenticationServices

class AuthViewModel: ObservableObject {
    @Published var authorizationCode: String = ""
    @Published var name: String = ""
    
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
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                let email = appleIDCredential.email
                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                
                DispatchQueue.main.async { /*[weak self] in*/
                    print("Name: \(name)")
                    print("Email: \(email)")
                    print("IdentityToken: \(identityToken)")
                    print("AuthorizationCode: \(authorizationCode)")
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
