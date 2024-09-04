//
//  MemberRequest.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

class MemberRequest {
    
    // 로그인
    struct SignIn: Codable {
        let code: String // 애플 인증 서버 코드
        let deviceToken: String
    }
    
    // 회원가입
    struct SignUp: Codable {
        let signUpToken: String
        let email: String
        let nickname: String
        let profileImage: String?
        let deviceToken: String
    }
    
    // 프로필 수정
    struct EditProfile: Codable {
        let nickname: String
        let profileImage: String?
    }
    
    // 회원가입 인증메일 발송
    struct EmailCertification: Codable {
        let signUpToken: String
        let email: String
    }
    
    // 인증코드 확인
    struct CodeCertification: Codable {
        let signUpToken: String
        let email: String
        let certCode: String
    }
}
