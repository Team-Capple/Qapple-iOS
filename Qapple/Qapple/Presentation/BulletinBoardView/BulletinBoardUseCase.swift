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

// MARK: - Test Data Set

private let dummyPosts: [Post] = [
    Post(anonymityIndex: 1,
         isMine: true,
         content: "오늘은 새로운 Swift 기능을 배웠어요!",
         isLike: true,
         likeCount: 12,
         commentCount: 3,
         writingDate: Date()),
    
    Post(anonymityIndex: 2,
         isMine: false,
         content: "좋아하는 밴드의 콘서트가 곧 열려요. 기대됩니다!",
         isLike: false,
         likeCount: 5,
         commentCount: 1,
         writingDate: Date().addingTimeInterval(-86400)),
    
    Post(anonymityIndex: 3,
         isMine: false,
         content: "오늘은 조용히 책을 읽으며 시간을 보냈어요.",
         isLike: true,
         likeCount: 8,
         commentCount: 0,
         writingDate: Date().addingTimeInterval(-172800)),
    
    Post(anonymityIndex: 4,
         isMine: true,
         content: "친구들과 함께하는 저녁 식사, 정말 즐거웠어요!",
         isLike: false,
         likeCount: 20,
         commentCount: 4,
         writingDate: Date().addingTimeInterval(-259200)),
    
    Post(anonymityIndex: 5,
         isMine: false,
         content: "새로운 프로젝트를 시작했어요. 앞으로 기대가 됩니다.",
         isLike: true,
         likeCount: 7,
         commentCount: 2,
         writingDate: Date().addingTimeInterval(-345600))
]
