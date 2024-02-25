//
//  ConfirmAnswerViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import Foundation

final class ConfirmAnswerViewModel: ObservableObject {
    
    @Published var answer: String
    
    init(answer: String) {
        self.answer = answer
    }
}

// MARK: - Text
extension ConfirmAnswerViewModel {
    
    var answerText: AttributedString {
        // A. Mark
        var answerMark = AttributedString("A. ")
        answerMark.foregroundColor = BrandPink.text
        let text = AttributedString(answer)
        return answerMark + text
    }
}
