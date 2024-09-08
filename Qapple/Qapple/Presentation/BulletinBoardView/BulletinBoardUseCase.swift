//
//  BulletinBoardUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation

final class BulletinBoardUseCase: ObservableObject {
    @Published var _state: State
    
    init() {
        self._state = State(
            currentEvent: "Prologue", // TODO: 실제 값 업데이트
            progress: 0.47, // TODO: 실제 값 업데이트
            posts: []
        )
        
        Task {
            await fetchPostList()
        }
    }
}

// MARK: - State

extension BulletinBoardUseCase {
    
    struct State {
        var currentEvent: String
        var progress: Double
        var posts: [Post]
    }
}

// MARK: - Effect

extension BulletinBoardUseCase {
    
    enum Effect {
        case fetchPost
        case likePost(postIndex: Int)
        case removePost(postIndex: Int)
        case reportPost(postIndex: Int)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .fetchPost:
            Task {
                await fetchPostList()
            }
        case .likePost(let postIndex):
            print("\(postIndex)번째 게시글 좋아요 업데이트")
            Task {
                try await NetworkManager.requestLikeBoard(.init(boardId: postIndex))
            }
            
        case .removePost(postIndex: let postIndex):
            print("\(postIndex)번째 게시글 삭제")
            Task {
                try await NetworkManager.requestDeleteBoard(.init(boardId: postIndex))
            }
            
        case .reportPost(postIndex: let postIndex):
            print("\(postIndex)번째 게시글 신고")
            // TODO: 신고 넣기
        }
    }
}
// MARK: - fetch

extension BulletinBoardUseCase {
    
    @MainActor
    private func fetchPostList() {
        Task {
            let boardList = try await NetworkManager.fetchBoard()
            
            let postList: [Post] = boardList.boards.map { board in
                Post(
                    anonymityIndex: board.boardId,
                    isMine: false, // TODO: 나중에 처리
                    content: board.content,
                    isLike: false, // TODO: 나중에 처리
                    likeCount: board.heartCount,
                    commentCount: board.commentCount,
                    writingDate: board.createAt.ISO8601ToDate
                )
            }
            
            _state.posts = postList
        }
    }
}
