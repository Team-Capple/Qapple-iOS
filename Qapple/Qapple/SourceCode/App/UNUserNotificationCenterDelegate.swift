//
//  UNUserNotificationCenterDelegate.swift
//  Qapple
//
//  Created by 김민준 on 2/21/25.
//

import UIKit

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// 푸시 메세지가 앱이 켜져있을 때 나올 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        
        pushNotificationTapped(
            title: notification.request.content.title,
            body: notification.request.content.body,
            userInfo: userInfo
        )
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    /// 푸시메세지를 받았을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        pushNotificationTapped(
            title: response.notification.request.content.title,
            body: response.notification.request.content.body,
            userInfo: userInfo
        )
        
        completionHandler()
    }
    
    /// Push Notification 탭 이벤트
    private func pushNotificationTapped(title: String, body: String, userInfo: [AnyHashable: Any]) {
        
        // 질문 Push 알림
        if let questionId = userInfo["questionId"],
           let idString = questionId as? String,
           let id = Int(idString) {
            // TODO: APNs에서 답변했는지 안했는지 여부를 알아야 함
            GAService.log(.navigateToQuestionTabFromPush(title: title, body: body, questionId: id))
            return
        }
        
        // 게시판 댓글 Push 알림
        if let boardId = userInfo["boardId"],
           let idString = boardId as? String,
           let id = Int(idString) {
            Task {
                do {
                    let board = try await bulletinBoardRepository.fetchSingleBoard(id)
                    mainFlowStore.send(.pushToComment(board))
                    GAService.log(.navigateToBoardCommentFromPush(title: title, body: body, board: board))
                } catch {
                    print("Failed to fetch single board")
                }
            }
        }
    }
}
