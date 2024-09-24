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
                        print("유효한 토큰 확인, 메인 화면으로 이동")
                        return completion(true)
                    } catch {
                        print("유효한 토큰 없음, 로그인 화면으로 이동")
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
