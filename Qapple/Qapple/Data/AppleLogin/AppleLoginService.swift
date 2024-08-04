//
//  AppleLoginService.swift
//  Qapple
//
//  Created by 김민준 on 8/4/24.
//

import Foundation
import AuthenticationServices

struct AppleLoginService {
    
    static func autoLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let userID = try? SignInInfo.shared.userID()
        
        appleIDProvider.getCredentialState(forUserID: userID ?? "") { (credentialState, error) in
            switch credentialState {
                case .authorized:
                   print("authorized")
                case .revoked:
                   print("revoked")
                case .notFound:
                   print("notFound")
                       
                default:
                    break
            }
        }
    }
}
