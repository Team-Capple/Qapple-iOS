//
//  Answer.swift
//  Qapple
//
//  Created by 김민준 on 8/20/24.
//

import Foundation

struct Answer: Identifiable {
    let id: Int
    let anonymityId: Int
    let content: String
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let writingDate: Date
    let isReported: Bool
}
