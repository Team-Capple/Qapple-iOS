//
//  NotificationUseCase.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import Foundation


final class NotificationUseCase: ObservableObject {
    
    @Published var _state: [State] = []
    
    init() {
        self._state = [
            State(targetContentId: "질문1", userName: "아무개2", actionType: .comment, commentContent: "저요!", timeStamp: Date(), isReadStatus: false),
            State(targetContentId: "질문2", userName: "아무개4", actionType: .like, commentContent: nil, timeStamp: Date(), isReadStatus: false),
            State(targetContentId: "질문3", userName: "아무개6", actionType: .comment, commentContent: "저는 시몬스랑 하고 싶어요!", timeStamp: Date(), isReadStatus: false)
        ]
    }
}

extension NotificationUseCase {
    
    struct State {
        let targetContentId: String // 어떤 게시물인지?
        let userName: String
        let actionType: NotificationActionType
        let commentContent: String?
        let timeStamp: Date
        let isReadStatus: Bool // 확인한건지?
    }
}

extension NotificationUseCase {
    
    enum NotificationActionType {
        case comment
        case like
        
        var description: String {
            switch self {
            case .comment:
                return "댓글을 달았어요"
            case .like:
                return "좋아요를 달았어요"
            }
        }
    }
}
