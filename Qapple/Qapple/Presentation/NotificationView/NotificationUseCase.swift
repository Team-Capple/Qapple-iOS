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
            State(userName: "아무개2", actionType: .comment, timeStamp: Date(), isReadStatus: false),
            State(userName: "아무개4", actionType: .like, timeStamp: Date(), isReadStatus: false),
            State(userName: "아무개6", actionType: .comment, timeStamp: Date(), isReadStatus: false)
        ]
    }
}

extension NotificationUseCase {
    
    struct State {
//        let targetContentId: String // 어떤 게시물인지?
        let userName: String
        let actionType: NotificationActionType
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
                return "좋아요를 눌렀어요"
            }
        }
    }
}
