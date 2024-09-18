//
//  BulletinBoardUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation

final class BulletinBoardUseCase: ObservableObject {
    @Published var _state: State
    @Published var isClickComment: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
        
        // 매크로 시작 날
        var startDateComponents = DateComponents()
        startDateComponents.year = 2024
        startDateComponents.month = 9
        startDateComponents.day = 2
        
        // 매크로 종료 날
        var endDateComponents = DateComponents()
        endDateComponents.year = 2024
        endDateComponents.month = 11
        endDateComponents.day = 29
        
        let calendar = Calendar.current
        
        self._state = State(
            currentEvent: "Macro", // TODO: 실제 값 업데이트
            startDate: calendar.date(from: startDateComponents)!, // TODO: 실제 값 업데이트
            endDate: calendar.date(from: endDateComponents)!, // TODO: 실제 값 업데이트
            posts: []
        )
    }
}

// MARK: - State

extension BulletinBoardUseCase {
    
    struct State {
        let currentEvent: String
        let startDate: Date
        let endDate: Date
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
            _state.posts[postIndex-1].isLiked.toggle()
            if _state.posts[postIndex-1].isLiked == true {
                _state.posts[postIndex-1].heartCount += 1
            } else {
                _state.posts[postIndex-1].heartCount -= 1
            }
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
    func fetchPostList() {
        self.isLoading = true
        
        Task {
            let boardList = try await NetworkManager.fetchBoard(.init(pageNumber: 0, pageSize: 100))
            
            let postList: [Post] = boardList.content.map { board in
                Post(
                    boardId: board.boardId,
                    writerId: board.writerId,
                    content: board.content,
                    heartCount: board.heartCount,
                    commentCount: board.commentCount,
                    createAt: board.createAt.ISO8601ToDate,
                    isMine: board.isMine,
                    isReported: board.isReported,
                    isLiked: board.isLiked
                )
            }
            
            _state.posts = postList
            self.isLoading = false
        }
    }
}
