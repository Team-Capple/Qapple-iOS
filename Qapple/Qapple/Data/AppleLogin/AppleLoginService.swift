//
//  AppleLoginService.swift
//  Qapple
//
//  Created by 김민준 on 8/4/24.
//

import Foundation
import AuthenticationServices

struct AppleLoginService {
    
    static func autoLogin(completion: @escaping (Bool) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let userID = try? SignInInfo.shared.userID()
        
        appleIDProvider.getCredentialState(forUserID: userID ?? "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                Task {
                    do {
                        let response = try await NetworkManager.refreshToken()
                        try SignInInfo.shared.createToken(.access, token: response.accessToken)
                        try SignInInfo.shared.createToken(.refresh, token: response.refreshToken)
                        
                        print("✅ [Auto Login Successed]\n")
                        print("✅ [AccessToken Successed]\n\(String(describing: try? SignInInfo.shared.token(.access)))\n")
                        print("✅ [RefreshToken Successed]\n\(String(describing: try? SignInInfo.shared.token(.refresh)))\n")
                        
                        return completion(true)
                    } catch {
                        return completion(false)
                    }
                }
                
            case .revoked, .notFound:
                print("❌ [Auto Login Failed]\n")
                return completion(false)
                
            default: return completion(false)
            }
        }
    }
}
