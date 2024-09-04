//
//  CommentUseCase.swift
//  Qapple
//
//  Created by 문인범 on 8/22/24.
//

import SwiftUI

final class CommentUseCase: ObservableObject {
    @Published public var _state: State
    
    init() {
        self._state = State(
            post: Post(
                anonymityIndex: 1,
                isMine: false,
                content: "지금 누가 팀이 있고 없는지 궁금해요",
                isLike: true,
                likeCount: 32,
                commentCount: 32,
                writingDate: Date().addingTimeInterval(-10)
            ),
            comment: sampleComments
        )
    }
}


extension CommentUseCase {
    struct State {
        let post: Post
        let comment: [Comment]
    }
}

extension CommentUseCase {
    enum Action {
        case upload(content: String)
        case delete(id: Int)
        case report(id: Int)
        case like(id: Int)
    }
    
    func act(_ action: Action) {
        switch action {
        case .upload(let content):
            // TODO: 댓글 업로드 기능 구현
            print("댓글 업로드: \(content)")
        case .delete(let id):
            // TODO: 댓글 삭제 기능 구현
            print("\(id)번째 댓글 삭제")
        case .report(let id):
            // TODO: 댓글 신고 기능 구현
            print("\(id)번째 댓글 신고")
        case .like(id: let id):
            // TODO: 댓글 좋아요 기능 구현
            print("\(id)번째 댓글 좋아요")
        }
    }
}


struct Comment: Identifiable {
    let id = UUID()
    let anonymityIndex: Int
    let isMine: Bool
    let isLike: Bool
    let likeCount: Int
    let content: String
    let timestamp: Date
}


private let sampleComments: [Comment] = [
    Comment(
        anonymityIndex: 1,
        isMine: false,
        isLike: false,
        likeCount: 10,
        content: "이말 완전 인정",
        timestamp: Date().addingTimeInterval(-60*60)
    ),
    Comment(
        anonymityIndex: 1,
        isMine: false,
        isLike: false,
        likeCount: 4,
        content: "22",
        timestamp: Date().addingTimeInterval(-60*58)
    ),
    Comment(
        anonymityIndex: 1,
        isMine: false,
        isLike: false,
        likeCount: 7,
        content: "나는 별로 안궁금한데?? 왜 이런거 궁금함? 난 이미 팀있지롱 ㅋ",
        timestamp: Date().addingTimeInterval(-86000)
    ),
    Comment(
        anonymityIndex: 1,
        isMine: false,
        isLike: true,
        likeCount: 23,
        content: "와 위 댓글 ㅁㅊ네",
        timestamp: Date().addingTimeInterval(-90000)
    ),
    Comment(
        anonymityIndex: 1,
        isMine: true,
        isLike: true,
        likeCount: 50,
        content: "왜 시비임? 현피ㄱ?",
        timestamp: Date().addingTimeInterval(-180)
    ),
    Comment(
        anonymityIndex: 1,
        isMine: false,
        isLike: true,
        likeCount: 83,
        content: "뜨던지ㅋ 목요일 오후 10시 지곡회관으로 와라",
        timestamp: Date().addingTimeInterval(-53)
    ),
    Comment(
        anonymityIndex: 1,
        isMine: true,
        isLike: true,
        likeCount: 125,
        content: "ㅋㅋ 한대 맞고 울지나 마라",
        timestamp: Date()
    ),
    Comment(
        anonymityIndex: 1,
        isMine: true,
        isLike: true,
        likeCount: 125,
        content: "ㅋㅋ 한대 맞고 울지나 마라",
        timestamp: Date().addingTimeInterval(-180000)
    ),
]
