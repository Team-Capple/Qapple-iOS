//
//  Post.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation

struct Post: Identifiable, Hashable {
    let id = UUID()
    let boardId: Int
    let writerId: Int
    let content: String
    var heartCount: Int
    var commentCount: Int
    let createAt: Date
    let isMine: Bool
    let isReported: Bool
    var isLiked: Bool
}
