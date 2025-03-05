//
//  NotificationTests.swift
//  QappleTests
//
//  Created by 문인범 on 3/5/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import Qapple


// MARK: - onAppear, refresh 관련
@MainActor
struct NotificationTests {
    @Test("첫 화면 데이터 패치")
    func onAppear() async throws {
        let store = TestStore(initialState: .init()) {
            NotificationFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear) { state in
            state.isLoading = true
            state.threshold = nil
            state.hasNext = false
        }
        
        await store.receive(\.fetchNotifications) { state in
            state.isLoading = false
        }
        #expect(store.state.notifications.count == 25)
    }
    
    @Test("첫 화면 데이터 패치 에러")
    func onAppearWithError() async throws {
        let store = TestStore(initialState: .init()) {
            NotificationFeature()
        } withDependencies: {
            $0.notificationRepository.fetchNotificationList = { _ in
                throw TestError.onAppearError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear) { state in
            state.isLoading = true
            state.threshold = nil
            state.hasNext = false
        }
        
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.onAppearError)
        }
    }
}


// MARK: - 페이지네이션 관련
extension NotificationTests {
    @Test("페이지네이션")
    func pagination() async throws {
        let store = TestStore(initialState: .init()) {
            NotificationFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear) { state in
            state.isLoading = true
            state.threshold = nil
            state.hasNext = false
        }
        await store.receive(\.fetchNotifications)
        
        await store.send(.onPaginationCellAppear(24))
        await store.receive(\.fetchNotifications) { state in
            state.isLoading = false
        }
        
        #expect(store.state.notifications.count == 50)
    }
    
    @Test("페이지네이션 에러")
    func paginationWithError() async throws {
        let store = TestStore(initialState: .init()) {
            NotificationFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear) { state in
            state.isLoading = true
            state.threshold = nil
            state.hasNext = false
        }
        await store.receive(\.fetchNotifications)
        
        store.dependencies.notificationRepository.fetchNotificationList = { _ in
            throw TestError.paginationError
        }
        
        await store.send(.onPaginationCellAppear(24))
        
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.paginationError)
        }
    }
}


// MARK: - 셀 터치 이벤트
extension NotificationTests {
    @Test("노티피케이션 셀 터치 이벤트", arguments: [
            QappleNotification( // 게시판 알람 with 정상 게시글
                questionId: "",
                boardId: "1",
                boardCommentId: "1",
                isResponsedQuestion: nil,
                isReportedBoard: false,
                title: "테스트",
                subtitle: nil,
                content: "테스트",
                createAt: .distantPast,
                isReadStatus: false
            ),
            QappleNotification( // 게시판 알람 with 신고 게시글
                questionId: "",
                boardId: "2",
                boardCommentId: "2",
                isResponsedQuestion: nil,
                isReportedBoard: true,
                title: "테스트",
                subtitle: nil,
                content: "테스트",
                createAt: .distantPast,
                isReadStatus: false
            ),
            QappleNotification( // 질문 알람 with 답하지 않은 질문
                questionId: "3",
                boardId: "",
                boardCommentId: nil,
                isResponsedQuestion: false,
                isReportedBoard: nil,
                title: "테스트",
                subtitle: nil,
                content: "테스트",
                createAt: .distantPast,
                isReadStatus: false
            ),
            QappleNotification( // 질문 알람 with 답한 질문
                questionId: "4",
                boardId: "",
                boardCommentId: nil,
                isResponsedQuestion: true,
                isReportedBoard: nil,
                title: "테스트",
                subtitle: nil,
                content: "테스트",
                createAt: .distantPast,
                isReadStatus: false
            )
    ])
    func notificationCellTapped(noti: QappleNotification) async throws {
        let store = TestStore(initialState: .init()) {
            NotificationFeature()
        } withDependencies: {
            $0.notificationRepository.fetchNotificationList = { _ in
                ([noti], .init(threshold: "1234", hasNext: true))
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.fetchNotifications)
        
        await store.send(.notificationCellTapped(0))
        
        if let questionId = Int(noti.questionId) {
            let isAnswered = noti.isResponsedQuestion!
            
            switch isAnswered {
            case true:
                await store.receive(\.navigateToAnswerList)
            case false:
                await store.receive(\.navigateToWriteAnswer)
            }
        } else {
            let boardId = Int(noti.boardId)!
            let isReported = noti.isReportedBoard!
            
            switch isReported {
            case true:
                await store.receive(\.reportedBoard)
            case false:
                await store.receive(\.navigateToComment)
            }
        }
        
    }
}


// MARK: - Test Stub
extension NotificationTests {
    private enum TestError: Error {
        case onAppearError
        case paginationError
    }
}
