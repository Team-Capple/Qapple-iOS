//
//  NotificationUseCase.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import Foundation


final class NotificationUseCase: ObservableObject {
    
    @Published var notificationList: [NotificationResponse.Content] = []
    @Published var _state: [State] = []
    
    init() {
        Task {
            await fetchNotificationList()
        }
    }
}

extension NotificationUseCase {
    
    @MainActor
    func fetchNotificationList() {
        Task {
            do {
                let notifications = try await NetworkManager.fetchNotificationList(
                    .init(
                        pageNumber: 0,
                        pageSize: 1000
                    )
                )
                
                self.notificationList = notifications.content
                print(self.notificationList)
            } catch {
                print("Notification List Error")
            }
        }
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
