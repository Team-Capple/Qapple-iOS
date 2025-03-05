//
//  BulletinBoard.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BulletinBoard: Identifiable, Equatable {
    let id: Int
    let writerId: Int
    let writerNickname: String
    let writerGeneration: String
    let content: String
    var heartCount: Int
    var commentCount: Int
    let createAt: Date
    let isMine: Bool
    let isReported: Bool
    var isLiked: Bool
}
