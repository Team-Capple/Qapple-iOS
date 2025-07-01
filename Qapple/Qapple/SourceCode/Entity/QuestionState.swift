//
//  QuestionState.swift
//  Capple
//
//  Created by 김민준 on 2/22/24.
//

import SwiftUI

/// 질문 관리 상태 열거형입니다.
enum QuestionState: Codable {
    
    /// 질문 생성 중
    case creating
    
    /// 질문 준비 완료
    case ready
    
    /// 질문 답변 완료
    case complete
    
    /// 질문 상태에 따라 변화하는 그래픽 이미지
    var graphicImage: ImageResource {
        switch self {
        case .creating: .questionCreate
        case .ready: .questionReady
        case .complete: .questionComplete
        }
    }
    
    /// 질문 상태에 따라 변화하는 제목 문자열
    var mainTitle: String {
        switch self {
        case .creating: "질문을 만들고 있어요"
        case .ready: "질문이 준비되었어요!"
        case .complete: "답변을 완료했어요!"
        }
    }
    
    /// 질문 및 답변 여부에 따라 변화하는 버튼 문자열
    func buttonTitle(isAnswerd: Bool) -> String {
        switch self {
        case .creating: isAnswerd ? "다른 답변 둘러보기" : "이전 질문 답변하기"
        case .ready: "질문에 답변하기"
        case .complete: "다른 답변 둘러보기"
        }
    }
}
