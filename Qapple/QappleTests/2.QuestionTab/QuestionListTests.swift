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
    
    @Test("답변 여부에 따른 질문 Cell 테스트", arguments: [
        Question(id: 0, content: "", publishedDate: .now, isAnswered: false, isLived: false),
        Question(id: 1, content: "", publishedDate: .now, isAnswered: true, isLived: false),
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
