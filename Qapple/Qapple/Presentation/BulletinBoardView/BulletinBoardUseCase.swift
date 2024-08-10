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
            posts: dummyPosts // TODO: 실제 게시글 업데이트
        )
    }
}

// MARK: - State

extension BulletinBoardUseCase {
    
    struct State {
        let currentEvent: String
        let progress: Double
        let posts: [Post]
    }
}

// MARK: - Effect

extension BulletinBoardUseCase {
    
    enum Effect {
        case likePost(postIndex: Int)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .likePost(let postIndex):
            print("\(postIndex)번째 게시글 좋아요 업데이트")
            // TODO: 네트워킹 좋아요 업데이트
        }
    }
}

// MARK: - Test Data Set

private let dummyPosts: [Post] = [
    Post(anonymityIndex: 1,
         content: "오늘 날씨가 정말 좋네요!",
         isLike: true,
         likeCount: 10,
         commentCount: 2,
         writingDate: Date()),
    
    Post(anonymityIndex: 2,
         content: "Swift 공부하는 중인데, 어렵지만 재밌어요.",
         isLike: false,
         likeCount: 3,
         commentCount: 0,
         writingDate: Date().addingTimeInterval(-86400)),
    
    Post(anonymityIndex: 3,
         content: "좋아하는 책이 영화로 나온다니 기대되네요!",
         isLike: true,
         likeCount: 15,
         commentCount: 5,
         writingDate: Date().addingTimeInterval(-172800)),
    
    Post(anonymityIndex: 4,
         content: "오늘 만든 요리가 정말 맛있었어요. 다음에 또 만들어야겠어요.",
         isLike: false,
         likeCount: 7,
         commentCount: 1,
         writingDate: Date().addingTimeInterval(-259200)),
    
    Post(anonymityIndex: 5,
         content: "친구들과 오랜만에 만나서 즐거운 시간을 보냈습니다.",
         isLike: true,
         likeCount: 20,
         commentCount: 8,
         writingDate: Date().addingTimeInterval(-345600))
]
