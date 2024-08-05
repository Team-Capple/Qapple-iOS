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
                print("authorized")
                print("액세스 토큰 값!\n\(try? SignInInfo.shared.token(.access))\n")
                print("리프레쉬 토큰 값!\n\(try? SignInInfo.shared.token(.refresh))\n")
                return completion(true)
                
            case .revoked, .notFound:
                print("자동 로그인 실패, 직접 로그인이 필요합니다.")
                return completion(false)
                
            default: return completion(false)
            }
        }
    }
}
