//
//  AnswerViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import Foundation

final class AnswerViewModel: ObservableObject {
    
    @Published var answerText: String
    
    let textLimited = 250
    
    init() {
        self.answerText = ""
    }
}

// MARK: - Text
extension AnswerViewModel {
    
    var questionText: AttributedString {
        // Q. Mark
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        let text: AttributedString = "아카데미 러너 중\n가장 마음에 드는 유형이 있나요?"
        return questionMark + text
    }
}
