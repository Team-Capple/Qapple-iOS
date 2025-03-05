//
//  NotificationRepository.swift
//  Qapple
//
//  Created by 문인범 on 1/27/25.
//

import Foundation
import QappleRepository
import ComposableArchitecture


/**
 캐플 앱 푸쉬 알림(Push Notification) 의존성
 */
struct NotificationRepository {
    var fetchNotificationList: (_ threshold: Int?) async throws -> ([QappleNotification], QappleAPI.PaginationInfo)
    var fetchSingleBoard: (_ boardId: Int) async throws -> BulletinBoard
    var isAnsweredQuestion: (_ questionId: Int) async throws -> (Bool, Question)
}

// MARK: - DependencyKey

extension NotificationRepository: DependencyKey {
    
    static let liveValue: NotificationRepository = Self(
        fetchNotificationList: { threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await NotificationAPI.fetchNotifications(
                    threshold: threshold,
                    pageSize: 25,
                    server: server,
                    accessToken: accessToken
                )
            }
            
            let result = response.content.map {
                QappleNotification(
                    id: $0.questionId ?? "",
                    boardId: $0.boardId ?? "",
                    boardCommentId: $0.boardCommentId,
                    title: $0.title,
                    subtitle: $0.subtitle,
                    content: $0.content ?? "",
                    createAt: $0.createdAt.ISO8601ToDate,
                    isReadStatus: false
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            
            return (result, paginationInfo)
        },
        fetchSingleBoard: { boardId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.fetchSingle(
                    boardId: boardId,
                    server: server,
                    accessToken: accessToken
                )
            }
            
            let result = BulletinBoard(
                id: response.boardId,
                writerId: response.writerId,
                writerNickname: response.writerNickname,
                writerGeneration: response.writerGeneration,
                content: response.content,
                heartCount: response.heartCount,
                commentCount: response.commentCount,
                createAt: response.createdAt.ISO8601ToDate,
                isMine: response.isMine,
                isReported: response.isReported,
                isLiked: response.isLiked
            )
            
            return result
        },
        isAnsweredQuestion: { questionId in
            var hasNext = true
            var threshold: String?
            
            while hasNext {
                let response = try await RepositoryService.shared.request { server, accessToken in
                    try await QuestionAPI.fetchQuestionList(
                        threshold: threshold,
                        pageSize: 25,
                        server: server,
                        accessToken: accessToken
                    )
                }
                
                if let question = response.content.first(where: { $0.questionId == questionId }) {
                    let entity = Question(
                        id: question.questionId,
                        content: question.content,
                        publishedDate: question.livedAt?.ISO8601ToDate ?? .init(),
                        isAnswered: question.isAnswered,
                        isLived: question.questionStatus == "LIVE"
                    )
                    
                    return (question.isAnswered, entity)
                }
                
                hasNext = response.hasNext
                threshold = response.threshold
            }
            
            // id에 맞는 질문 찾기 실패시 에러 던지기
            throw NSError()
        }
    )
    
    static let previewValue: NotificationRepository = Self(
        fetchNotificationList: { _ in
            (NotificationRepository.dummyNoti, .init(threshold: "", hasNext: true))
        },
        fetchSingleBoard: { _ in
            NotificationRepository.dummyBoard
        },
        isAnsweredQuestion: { _ in
            let question = Question(
                id: 1234,
                content: "테스트 질문 입니다.",
                publishedDate: .init(),
                isAnswered: false,
                isLived: true
            )
            
            return (false, question)
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var notificationRepository: NotificationRepository {
        get { self[NotificationRepository.self] }
        set { self[NotificationRepository.self] = newValue }
    }
}

// MARK: - Test Value

extension NotificationRepository {
    
    private static let dummyNoti: [QappleNotification] = {
        var result = [QappleNotification]()
        for i in 0 ..< 25 {
            result.append(.init(
                id: String(i),
                boardId: String(i),
                boardCommentId: nil,
                title: "테스트입니다 \(i)",
                subtitle: nil,
                content: "테스트 컨텐츠 입니다 \(i)",
                createAt: Date(timeIntervalSinceNow: Double(-60*60*60*i)),
                isReadStatus: false
            ))
        }
        return result
    }()
    
    private static let dummyBoard = BulletinBoard(
        id: 1,
        writerId: 1,
        writerNickname: "이호창",
        writerGeneration: "3기",
        content: "특전사",
        heartCount: 10,
        commentCount: 13,
        createAt: .init(),
        isMine: false,
        isReported: false,
        isLiked: true
    )
}
