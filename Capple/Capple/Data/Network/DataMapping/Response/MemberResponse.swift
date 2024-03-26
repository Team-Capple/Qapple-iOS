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
    
    struct SignUp: Codable {
        let accessToken: String?
        let refreshToken: String?
    }
    
    struct MyPage: Codable {
        let nickname: String
        let profileImage: String?
        let joinDate: String
    }
    
    struct EditProfile: Codable {
        let nickname: String
        let profileImage: String?
        let memberId: Int
    }
    
    struct NicknameCheck: Codable {
        let timeStamp: String
        let code: String
        let message: String
        let result: Bool
    }
}
