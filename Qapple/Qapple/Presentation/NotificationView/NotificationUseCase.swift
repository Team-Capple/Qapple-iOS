//
//  NotificationUseCase.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import Foundation

final class NotificationUseCase: ObservableObject {
    
    @Published var state: State
    
    init() {
        self.state = State()
        
        Task {
            await fetchNotificationList()
        }
    }
}

// MARK: - State

extension NotificationUseCase {
    
    struct State {
        var notificationList: [QappleNoti] = []
        var isLoading: Bool = true
        var threshold: Int?
        var hasNext: Bool = false
    }
}

// MARK: - UseCase Method

extension NotificationUseCase {
    
    @MainActor
    func fetchNotificationList() {
        state.isLoading = true
        
        Task {
            do {
                let response = try await NetworkManager.fetchNotificationList(
                    .init(
                        threshold: state.threshold,
                        pageSize: 25
                    )
                )
                
                state.notificationList += response.content.map {
                    QappleNoti(
                        questionId: $0.questionId ?? "",
                        boardId: $0.boardId ?? "",
                        boardCommentId: $0.boardCommentId,
                        title: $0.title,
                        subtitle: $0.subtitle,
                        content: $0.content ?? "",
                        createAt: $0.createdAt.ISO8601ToDate,
                        isReadStatus: false
                    )
                }
                
                state.threshold = Int(response.threshold)
                state.hasNext = response.hasNext
                state.isLoading = false
            } catch {
                print("Notification을 불러오는데 실패했습니다.")
                state.isLoading = false
            }
        }
    }
    
    @MainActor
    func refreshNotificationList() {
        state.isLoading = true
        
        /// 초기화
        state.hasNext = false
        
        Task {
            do {
                let notificationList = try await NetworkManager.fetchNotificationList(
                    .init(
                        threshold: nil,
                        pageSize: 25
                    )
                )
                
                state.notificationList.removeAll()
                state.notificationList += notificationList.content.map {
                    QappleNoti(
                        questionId: $0.questionId ?? "",
                        boardId: $0.boardId ?? "",
                        boardCommentId: $0.boardCommentId,
                        title: $0.title,
                        subtitle: $0.subtitle,
                        content: $0.content ?? "",
                        createAt: $0.createdAt.ISO8601ToDate,
                        isReadStatus: false
                    )
                }
                
                state.threshold = Int(notificationList.threshold)
                state.hasNext = notificationList.hasNext
                state.isLoading = false
            } catch {
                print("Notification을 불러오는데 실패했습니다.")
                state.isLoading = false
            }
        }
    }
}
