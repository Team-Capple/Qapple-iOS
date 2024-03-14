//
//  MemberResponse.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

struct MemberResponse {
    
    struct SignIn: Codable {
        let accessToken: String?
        let refreshToken: String?
        let isMember: Bool
    }
}
