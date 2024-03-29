//
//  ApiEnpoints.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import Foundation

enum ApiEndpoints {
    static let scheme = "http"
    static let host = "43.203.126.187"
    static let port = 8080
    
    enum Path: String {
        
        // MARK: - 질문
        case questions = "/questions"
        case mainQuestion = "/questions/main"
        
        // MARK: - 태그
        case tagSearch = "/tags/search?"
        case popularTagsInQuestion = "/tags"
        
        // MARK: - 답변
        case answersOfQuestion = "/answers/question"
        
        // MARK: - 멤버
        case signIn = "/members/sign-in"
        case signUp = "/members/sign-up"
        case myPage = "/members/mypage"
        case resignMember = "/members/resign"
        case nickNameCheck = "/members/nickname/check"
        
        // 이메일
        case emailCertification = "/members/email/certification"
    }
}

extension ApiEndpoints {
    
    /// 기본 URL 주소 문자열을 반환합니다.
    static func basicURLString(path: ApiEndpoints.Path) -> String {
        return "\(scheme)://\(host):\(port)\(path.rawValue)"
    }
}
