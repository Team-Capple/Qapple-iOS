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
                isQuestion: false,
                targetContent: "'어떤 게시글인지가 들어갑니다.'",
                userName: "000",
                actionType: .comment,
                commentContent: "내용이 들어갑니다.",
                timeStamp: Date(),
                isReadStatus: false
            ),
            State(
                isQuestion: false,
                targetContent: "'어떤 게시글인지가 들어갑니다.'",
                userName: "000",
                actionType: .like,
                commentContent: nil,
                timeStamp: Date(),
                isReadStatus: false
            ),
            State(
                isQuestion: true,
                targetContent: "'어떤 질문인지가 들어갑니다.'",
                userName: "",
                actionType: .question,
                commentContent: "오전 질문이 마감 되었어요\n다른 러너들은 어떻게 답 했는지 확인해보세요",
                timeStamp: Date(),
                isReadStatus: false
            ),
            State(
                isQuestion: false,
                targetContent: "'매크로 무슨팀과 함께하고 싶어요?'",
                userName: "아무개6",
                actionType: .comment,
                commentContent: "저는 시몬스랑 하고 싶어요!",
                timeStamp: Date(),
                isReadStatus: false
            )
        ]
    }
}

extension NotificationUseCase {
    
    struct State {
        let isQuestion: Bool
        let targetContent: String // 어떤 게시물인지?
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
        case question
        
        var description: String {
            switch self {
            case .comment:
                return "댓글을 달았어요"
            case .like:
                return "좋아요를 달았어요"
            case .question:
                return "오전 질문 마감 알림"
            }
        }
    }
}
