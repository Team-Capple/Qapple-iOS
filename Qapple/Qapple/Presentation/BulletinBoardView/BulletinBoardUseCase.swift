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
            posts: dummyPosts // TODO: 실제 게시글 업데이트
        )
    }
}

// MARK: - State

extension BulletinBoardUseCase {
    
    struct State {
        let currentEvent: String
        let startDate: Date
        let endDate: Date
        let posts: [Post]
    }
}

// MARK: - Effect

extension BulletinBoardUseCase {
    
    enum Effect {
        case likePost(postIndex: Int)
        case removePost(postIndex: Int)
        case reportPost(postIndex: Int)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .likePost(let postIndex):
            print("\(postIndex)번째 게시글 좋아요 업데이트")
            // TODO: 네트워킹 좋아요 업데이트
            
        case .removePost(postIndex: let postIndex):
            print("\(postIndex)번째 게시글 삭제")
            
        case .reportPost(postIndex: let postIndex):
            print("\(postIndex)번째 게시글 신고")
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
