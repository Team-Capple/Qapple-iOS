//
//  PathModel.swift
//  Capple
//
//  Created by 김민준 on 3/9/24.
//

import Foundation

enum PathType: Hashable {
    
    /// 로그인&회원가입
    case email // 이메일 인증
    case authCode // 인증 코드 입력
    case inputNickName // 닉네임 입력
    case agreement // 약관 동의
    case privacy // 개인정보 처리방침
    case terms // 서비스 이용 약관
    case signUpCompleted // 완료
    
    /// 답변하기
    case answer(questionId: Int, questionContent: String) // 답변하기
    case confirmAnswer // 답변확인(키워드선택)
    case searchKeyword // 키워드 검색
    case completeAnswer // 답변 완료
    
    /// 모아보기
    case todayAnswer(questionId: Int, questionContent: String)
    
    /// 마이페이지
    case myPage
    case profileEdit(nickname: String)
    case writtenAnswer
    
    // 알림 및 신고
    case notifications
    case alert
    case report(answerId: Int)
    
    // 게시판
    case bulletinSearch
    case bulletinPosting
}

class PathModel: ObservableObject {
    
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}

enum TestPathType: Hashable {
    case questionList
    case bulletinBoard
    case myProfile

}



enum QuestionListPathType: Hashable {
    /// 답변하기
    case answer(questionId: Int, questionContent: String) // 답변하기
    case confirmAnswer // 답변확인(키워드선택)
    case searchKeyword // 키워드 검색
    case completeAnswer // 답변 완료
    case notifications
}

enum BulletinBoardPathType: Hashable {
    // 게시판
    case bulletinSearch
    case bulletinPosting
}


enum MyProfilePathType: Hashable {
    /// 마이페이지
    case myPage
    case profileEdit(nickname: String)
    case writtenAnswer
}
