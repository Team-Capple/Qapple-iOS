//
//  AnswerConfirmViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import Foundation

final class AnswerConfirmViewModel: ObservableObject {
    
}

// MARK: - Text
extension AnswerConfirmViewModel {
    
    var answerText: AttributedString {
        // A. Mark
        var answerMark = AttributedString("A. ")
        answerMark.foregroundColor = BrandPink.text
        let text: AttributedString = "생각이 깊고 마음이 따뜻한 사람이 좋은 것 같아요. 함께 프로젝트를 진행하며 믿고 의지할 수 있잖아요 그렇죠? 저는 그렇게 생각하는데 다른 사람들은 모르겠네요 ㅎㅎ"
        return answerMark + text
    }
}
