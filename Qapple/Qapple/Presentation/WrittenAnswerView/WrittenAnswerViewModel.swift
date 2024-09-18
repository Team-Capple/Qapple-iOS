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
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func requestAnswers() async {
        do {
            let answers = try await NetworkManager.fetchAnswers()
            self.myAnswers = answers.content
        } catch {
            print("답변 업데이트")
        }
        isLoading = false
    }
}
