//
//  QuestionTimeZone.swift
//  Capple
//
//  Created by 김민준 on 2/22/24.
//

import Foundation

/// 질문시간대 열거형입니다.
enum QuestionTimeZone: String, Codable {
    case am = "오전" // 오전 답변 시간
    case pm = "오후" // 오후 답변 시간
    case amCreate // 오전 질문 생성 시간
    case pmCreate // 오후 질문 생성 시간
}
