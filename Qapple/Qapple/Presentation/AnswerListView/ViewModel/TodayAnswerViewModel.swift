
//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation

class AnswerListViewModel: ObservableObject {
    
    @Published var keywords: [String] = []
    @Published var todayQuestion: String = ""
    @Published var answers: [AnswerResponse.AnswersOfQuestion.Content] = []
    @Published var isLoading = true
    
    /// 답변 호출 API입니다.
    @MainActor
    func loadAnswersForQuestion(questionId: Int) {
        Task {
            do {
                let response = try await NetworkManager.fetchAnswersOfQuestion(
                    request: .init(
                        questionId: questionId,
                        pageNumber: 0,
                        pageSize: 1000
                    )
                )
                
                self.answers = response.content
            } catch {
                print("답변 리스트 호출 실패")
            }
            self.isLoading = false
        }
    }
}
