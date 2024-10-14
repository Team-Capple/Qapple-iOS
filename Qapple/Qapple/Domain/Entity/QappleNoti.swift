//
//  Notification.swift
//  Qapple
//
//  Created by 김민준 on 9/21/24.
//

import Foundation

struct QappleNoti: Identifiable {
    let id = UUID()
    let questionId: String
    let boardId: String
    let boardCommentId: String?
    let title: String
    let subtitle: String?
    let content: String
    let createAt: Date
    let isReadStatus: Bool // 확인한건지?
}
