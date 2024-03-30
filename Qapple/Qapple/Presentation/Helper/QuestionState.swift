//
//  QuestionState.swift
//  Capple
//
//  Created by 김민준 on 2/22/24.
//

import Foundation

/// 질문 관리 상태 열거형입니다.
enum QuestionState: Codable {
    case creating // 질문 생성 중
    case ready // 질문 준비
    case complete // 질문 답변 완료
}
