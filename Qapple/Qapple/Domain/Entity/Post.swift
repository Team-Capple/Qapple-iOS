//
//  Post.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation

struct Post: Identifiable, Hashable {
    let id = UUID()
    let anonymityIndex: Int
    let isMine: Bool
    let content: String
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let writingDate: Date
}
