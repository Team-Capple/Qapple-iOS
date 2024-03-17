//
//  SignInInfo.swift
//  Capple
//
//  Created by 김민준 on 3/17/24.
//

import Foundation

final class SignInInfo {
    
    static let shared = SignInInfo()
    private init() {}
    
    private var accessTokenValue: String = ""
    private var refreshTokenValue: String = ""
    
    /// 액세스 토큰을 반환합니다.
    func accessToken() -> String {
        return accessTokenValue
    }
    
    /// 액세스 토큰을 업데이트합니다.
    func updateAccessToken(_ token: String) {
        accessTokenValue = token
    }
    
    /// 리프레쉬 토큰을 반환합니다.
    func refreshToken() -> String {
        return refreshTokenValue
    }
    
    /// 리프레쉬 토큰을 업데이트합니다.
    func updateRefreshToken(_ token: String) {
        refreshTokenValue = token
    }
}
