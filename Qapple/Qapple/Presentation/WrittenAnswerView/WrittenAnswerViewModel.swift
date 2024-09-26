//
//  WrittenAnswerViewModel.swift
//  Qapple
//
//  Created by 김민준 on 4/12/24.
//

import Foundation

final class WrittenAnswerViewModel: ObservableObject {
    
    @Published var myAnswers: [AnswerResponse.Answers.Content] = []
    @Published var isLoading = true
    @Published var pageNumber: Int = 0
    @Published var hasPrevious: Bool = false
    @Published var hasNext: Bool = false
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func fetchAnswers() async {
        do {
            let answers = try await NetworkManager.fetchAnswers(
                pageNumber: pageNumber,
                pageSize: 25
            )
            
            self.myAnswers += answers.content
            self.pageNumber += 1
            self.hasPrevious = answers.hasPrevious
            self.hasNext = answers.hasNext
        } catch {
            print("답변 업데이트")
        }
        isLoading = false
    }
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func refreshAnswers() async {
        self.pageNumber = 0
        self.hasPrevious = false
        self.hasNext = false
        
        do {
            let answers = try await NetworkManager.fetchAnswers(
                pageNumber: pageNumber,
                pageSize: 25
            )
            
            self.myAnswers.removeAll()
            self.myAnswers += answers.content
            self.pageNumber += 1
            self.hasPrevious = answers.hasPrevious
            self.hasNext = answers.hasNext
        } catch {
            print("답변 업데이트")
        }
        isLoading = false
    }
}
