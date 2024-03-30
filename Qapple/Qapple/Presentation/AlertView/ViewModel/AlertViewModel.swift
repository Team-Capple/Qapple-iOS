//
//  AlertViewModel.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import Foundation

final class AlertViewModel: ObservableObject {
    
     @Published var alerts = [
        Alert(
            title: "오전 질문 마감 알림",
            contents: "오전 질문이 마감되었어요\n다른 러너들은 어떻게 답했는지 확인해보세요",
            question: "Q. 최근에 먹었던 음식 중 가장 인상깊었던 것은 무엇인가요?"
        ),
        Alert(
            title: "돌쇠님이 좋아요 눌렀습니다",
            contents: "저는 오늘 밥을 먹었습... 회원님의 답변에 반응을 남겼습니다.",
            question: "Q. 어떤게 제일 맛있었나요?"
        ),
        Alert(
            title: "오전 질문 마 알림",
            contents: "오전 질문이 마감되었어요\n다른 러너들은 어떻게 답했는지 확인해보세요",
            question: "Q. 최근에 먹었던 음식 중 가장 인상깊었던 것은 무엇인가요?"
        ),
        Alert(
            title: "돌쇠님이 좋아요를 눌렀습니다",
            contents: "저는 오늘 밥을 먹었습... 회원님의 답변에 반응을 남겼습니다.",
            question: "Q. 어떤게 제일 맛있었나요?"
        )
    ]
    
}
