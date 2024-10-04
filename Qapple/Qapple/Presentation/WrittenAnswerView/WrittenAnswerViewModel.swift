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
    
    @Published var threshold: Int?
    @Published var hasNext: Bool = false
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func fetchAnswers() async {
        do {
            let response = try await NetworkManager.fetchAnswers(
                threshold: threshold,
                pageSize: 25
            )
            
            self.myAnswers += response.content
            self.threshold = Int(response.threshold)
            self.hasNext = response.hasNext
        } catch {
            print("답변 업데이트")
        }
        isLoading = false
    }
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func refreshAnswers() async {
        self.hasNext = false
        
        do {
            let response = try await NetworkManager.fetchAnswers(
                threshold: nil,
                pageSize: 25
            )
            
            self.myAnswers.removeAll()
            self.myAnswers += response.content
            self.threshold = Int(response.threshold)
            self.hasNext = response.hasNext
        } catch {
            print("답변 업데이트")
        }
        isLoading = false
    }
}
