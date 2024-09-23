//
//  TokenResponse.swift
//  Qapple
//
//  Created by 김민준 on 9/23/24.
//

import Foundation

struct TokenResponse: Codable {
    
    struct Refresh: Codable {
        let accessToken: String
        let refreshToken: String
    }
}
