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
    case signUpCompleted // 완료
    
    /// 답변하기
    case answer // 답변하기
    case confirmAnswer // 답변확인(키워드선택)
    case searchKeyword // 키워드 검색
    
    /// 모아보기
    case todayAnswer
    
    /// 마이페이지
    case myPage
    case profileEdit
    
    // 알림 및 신고
    case alert
    case report
}

class PathModel: ObservableObject {
    
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
