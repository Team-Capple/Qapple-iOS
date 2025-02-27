//
//  QuestionListTests.swift
//  QappleTests
//
//  Created by 김민준 on 2/26/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import Qapple

@MainActor
struct QuestionListTests {
    
    let testPaginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
    
    let testQuestionList = [
        Question(id: 0, content: "", publishedDate: .now, isAnswered: false, isLived: false),
        Question(id: 1, content: "", publishedDate: .now, isAnswered: false, isLived: false),
        Question(id: 2, content: "", publishedDate: .now, isAnswered: false, isLived: false)
    ]
    
    @Test("질문리스트 첫 화면 테스트")
    func onAppear() async throws {
        let store = TestStore(initialState: .init()) {
            QuestionListFeature()
        } withDependencies: {
            $0.questionRepository.fetchQuestionList = { _ in
                (testQuestionList, testQuestionList.count, testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.questionListResponse) {
            $0.questionList = testQuestionList
            $0.totalCount = testQuestionList.count
            $0.paginationInfo = testPaginationInfo
        }
    }
    
    @Test("페이지네이션 테스트")
    func pagination() async throws {
        let store = TestStore(initialState: .init()) {
            QuestionListFeature()
        } withDependencies: {
            $0.questionRepository.fetchQuestionList = { _ in
                (testQuestionList, testQuestionList.count * 2, testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.send(.pagination)
        await store.receive(\.paginationResponse) {
            $0.questionList = testQuestionList + testQuestionList
            $0.totalCount = testQuestionList.count * 2
            $0.paginationInfo = testPaginationInfo
        }
    }
    
    @Test("네트워킹 실패 테스트")
    func networkingFailed() async throws {
        let store = TestStore(initialState: .init()) {
            QuestionListFeature()
        } withDependencies: {
            $0.questionRepository.fetchQuestionList = { _ in
                throw TestError.networkingError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.networkingFailed) {
            $0.alert = .failedNetworking(with: TestError.networkingError)
        }
        await store.send(.pagination)
        await store.receive(\.networkingFailed) {
            $0.alert = .failedNetworking(with: TestError.networkingError)
        }
    }
    
    @Test("답변 여부에 따른 질문 Cell 테스트", arguments: [
        Question(id: 0, content: "", publishedDate: .now, isAnswered: false, isLived: false),
        Question(id: 1, content: "", publishedDate: .now, isAnswered: true, isLived: false)
    ])
    func questionCellTapped(argument: Question) async throws {
        let store = TestStore(initialState: .init()) {
            QuestionListFeature()
        } withDependencies: {
            $0.questionRepository.fetchQuestionList = { _ in
                ([argument], 1, testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.questionListResponse)
        await store.send(.questionCellTapped(store.state.questionList.first!)) {
            if !$0.questionList.first!.isAnswered {
                $0.alert = .answeringCheck
            }
        }
    }
}
