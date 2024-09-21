//
//  Answer.swift
//  Qapple
//
//  Created by 김민준 on 8/20/24.
//

import Foundation

struct Answer: Identifiable {
    let id: Int
    let writerId: Int
    let learnerIndex: Int
    let nickname: String
    let content: String
    let writingDate: Date
    let isMine: Bool
    let isReported: Bool
}
