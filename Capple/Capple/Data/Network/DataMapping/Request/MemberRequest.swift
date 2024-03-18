//
//  MemberRequest.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

class MemberRequest {
    
    struct SignIn: Codable {
        let code: String // 애플 인증 서버 코드
    }
    
    struct SignUp: Codable {
        let signUpToken: String
        let nickname: String
        let profileImage: String?
    }
}
