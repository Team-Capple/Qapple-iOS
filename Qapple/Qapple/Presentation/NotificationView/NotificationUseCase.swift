//
//  NotificationUseCase.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import Foundation


final class NotificationUseCase: ObservableObject {
    
    @Published var _state: State
    
    init() {
        self._state = State(
            notificationList: []
        )
        
        Task {
            await fetchNotificationList()
        }
    }
}

// MARK: - State

extension NotificationUseCase {
    
    struct State {
        var notificationList: [QappleNoti]
        var isLoading: Bool = true
    }
}

// MARK: - UseCase Method

extension NotificationUseCase {
    
    @MainActor
    func fetchNotificationList() {
        _state.isLoading = true
        
        Task {
            do {
                let notificationList = try await NetworkManager.fetchNotificationList(
                    .init(
                        pageNumber: 0,
                        pageSize: 1000
                    )
                )
                
                _state.notificationList = notificationList.content.map {
                    QappleNoti(
                        boardId: $0.boardId,
                        boardCommentId: $0.boardCommentId,
                        title: $0.title,
                        subtitle: $0.subtitle,
                        content: $0.content,
                        createAt: $0.createdAt.ISO8601ToDate,
                        isReadStatus: false
                    )
                }
                
                _state.isLoading = false
            } catch {
                print("Notification을 불러오는데 실패했습니다.")
                _state.isLoading = false
            }
        }
    }
}
