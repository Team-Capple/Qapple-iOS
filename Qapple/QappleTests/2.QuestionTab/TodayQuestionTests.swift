//
//  TodayQuestionTests.swift
//  QappleTests
//
//  Created by 김민준 on 2/26/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import Qapple

@MainActor
struct TodayQuestionTests {
    
    let testClock = TestClock()
    
    let testQuestion = Question(
        id: 0,
        content: "오늘의 메인 질문",
        publishedDate: .now,
        isAnswered: true,
        isLived: true
    )
    
    let testAnswerList = Array(repeating: Answer(
        id: 0,
        content: "테스트 답변 1",
        authorNickname: "어쩌구",
        publishedDate: .now,
        isReported: false,
        isMine: false,
        isResignMember: false
    ), count: 3)
    
    @Test("오늘의 질문 화면 첫 상태 테스트")
    func onAppear() async throws {
        let store = TestStore(initialState: .init()) {
            TodayQuestionFeature()
        } withDependencies: {
            $0.questionRepository.fetchMainQuestion = { testQuestion }
            $0.answerRepository.fetchAnswerPreviewList = { _ in testAnswerList }
            $0.continuousClock = testClock
            $0.date = .constant(.now)
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.mainQuestionResponse) {
            $0.todayQuestion = testQuestion
        }
        await store.receive(\.answerListResponse) {
            $0.answerPreviewList = testAnswerList
        }
    }
    
    @Test("네트워킹 실패 테스트")
    func networkingFailed() async throws {
        let store = TestStore(initialState: .init()) {
            TodayQuestionFeature()
        } withDependencies: {
            $0.questionRepository.fetchMainQuestion = {
                throw TestError.networkingError
            }
            $0.answerRepository.fetchAnswerPreviewList = { _ in
                throw TestError.networkingError
            }
            $0.continuousClock = testClock
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.networkingFailed) {
            $0.alert = .failedNetworking(with: TestError.networkingError)
        }
    }
    
    @Test("질문 상태 테스트", arguments: await testDates())
    func questionStatus(date: Date) async throws {
        let store = TestStore(initialState: .init()) {
            TodayQuestionFeature()
        } withDependencies: {
            $0.questionRepository.fetchMainQuestion = {
                Question(
                    id: 0,
                    content: "",
                    publishedDate: .now,
                    isAnswered: .random(),
                    isLived: .random()
                )
            }
            $0.answerRepository.fetchAnswerPreviewList = { _ in testAnswerList }
            $0.continuousClock = testClock
            $0.date = .constant(date)
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.mainQuestionResponse) {
            let hour = Calendar.current.component(.hour, from: date)
            switch hour {
            case 13...20: $0.questionState = $0.todayQuestion.isAnswered ? .complete : .ready
            default: $0.questionState = .creating
            }
        }
    }
}

// MARK: - Helper

extension TodayQuestionTests {
    
    /// 0시부터 23시까지 테스트 날짜를 생성합니다.
    static func testDates() async -> [Date] {
        let calendar = Calendar.current
        return (0...23).compactMap { hour in
            calendar.date(bySettingHour: hour, minute: 0, second: 0, of: .now)
        }
    }
}
