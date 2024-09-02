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
            State(
                targetContent: "'어떤 게시글인지가 들어갑니다.'",
                targetType: .board,
                actionType: .comment,
                commentContent: "내용이 들어갑니다.",
                timeStamp: Date(),
                likeCount: 8,
                isReadStatus: false
            ),
            State(
                targetContent: "'어떤 게시글인지가 들어갑니다.'",
                targetType: .board,
                actionType: .like,
                commentContent: nil,
                timeStamp: Date(),
                likeCount: 18,
                isReadStatus: false
            ),
            State(
                targetContent: "'어떤 질문인지가 들어갑니다.'",
                targetType: .complete,
                actionType: .question,
                commentContent: "오전 질문이 마감 되었어요\n다른 러너들은 어떻게 답 했는지 확인해보세요",
                timeStamp: Date(),
                likeCount: 28,
                isReadStatus: false
            ),
            State(
                targetContent: "'매크로 무슨팀과 함께하고 싶어요?'",
                targetType: .answer,
                actionType: .comment,
                commentContent: "저는 시몬스랑 하고 싶어요!",
                timeStamp: Date(),
                likeCount: 1818,
                isReadStatus: false
            )
        ]
    }
}

extension NotificationUseCase {
    
    struct State {
        let targetContent: String // 어떤 게시물인지?
        let targetType: NotificationTargetType
        let actionType: NotificationActionType
        let commentContent: String?
        let timeStamp: Date
        let likeCount: Int
        let isReadStatus: Bool // 확인한건지?
    }
}

extension NotificationUseCase {
    
    enum NotificationTargetType {
        case answer
        case board
        case ready
        case complete
    
        var description: String {
            switch self {
            case .answer:
                return "댓글"
            case .board:
                return "게시물"
            case .ready:
                return "준비 완료!"
            case .complete:
                return "마감 알림"
            }
        }
    }
}

extension NotificationUseCase {
    
    enum NotificationActionType {
        case comment
        case like
        case question
        
        var description: String {
            switch self {
            case .comment:
                return "댓글을 달았어요"
            case .like:
                return "좋아요를 눌렀어요"
            case .question:
                return "오늘의 질문 "
            }
        }
    }
}
