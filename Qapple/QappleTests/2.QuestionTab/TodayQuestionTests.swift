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
        isAnswered: false,
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
}
