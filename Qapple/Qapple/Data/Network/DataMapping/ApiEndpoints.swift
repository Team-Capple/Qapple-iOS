//
//  ApiEnpoints.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import Foundation

enum ApiEndpoints {
    
    static let scheme = "http"
    
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
        case codeCertification = "/members/email/certification/check"
    }
}

extension ApiEndpoints {
    
    /// 기본 URL 주소 문자열을 반환합니다.
    static func basicURLString(path: ApiEndpoints.Path) -> String {
        guard let host = Bundle.main
            .object(forInfoDictionaryKey: "HOST_URL") as? String,
              let port = Bundle.main
            .object(forInfoDictionaryKey: "PORT_NUM") as? String
        else { return "" }
        
        return "\(scheme)://\(host):\(port)\(path.rawValue)"
    }
}
