//
//  AnswerViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import Foundation

final class AnswerViewModel: ObservableObject {
    
    var question: AttributedString
    
    @Published var mainQuestion: QuestionResponse.MainQuestion
    
    @Published var answer: String
    @Published var search: String
    
    @Published var keywords: [Keyword]
    @Published var keywordPreviews: [Keyword]
    
    let textLimited = 250
    
    init() {
        self.question = "아카데미 러너 중\n가장 마음에 드는 유형이 있나요?" // TODO: - 네트워킹 붙이면서 수정할 것
        self.answer = ""
        self.search = ""
        
        self.keywords = []
        
        self.keywordPreviews = [
            .init(name: "와플유니버시티"),
            .init(name: "당근맨"),
            .init(name: "무자비"),
            .init(name: "잔망루피"),
            .init(name: "애플"),
            .init(name: "아카데미"),
            .init(name: "디벨로퍼"),
            .init(name: "디자이너"),
            .init(name: "맨유리버풀첼시토트넘아스날맨시티뉴캐슬울버햄튼브라이튼아스톤빌라"),
        ]
        
        self.mainQuestion = .init(questionId: 0, questionStatus: "", content: "", isAnswered: false)
    }
}

// MARK: - 메인 질문 업데이트
extension AnswerViewModel {
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func requestMainQuestion() async {
        do {
            let mainQuestion = try await NetworkManager.fetchMainQuestion()
            self.mainQuestion = mainQuestion
        } catch {
            print("메인 질문 업데이트 실패")
        }
    }
}

// MARK: - Text
extension AnswerViewModel {
    
    /// 질문 텍스트를 반환합니다.
    var questionText: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        let attributeText = AttributedString(stringLiteral: mainQuestion.content)
        return questionMark + attributeText
    }
    
    /// 작성한 답변 텍스트를 반환합니다.
    var answerText: AttributedString {
        // A. Mark
        var answerMark = AttributedString("A. ")
        answerMark.foregroundColor = BrandPink.text
        let text = AttributedString(answer)
        return answerMark + text
    }
    
    /// FlexView 적용을 위한 키워드 배열을 반환합니다.
    var flexKeywords: [Keyword] {
        var newKeywords = keywords
        newKeywords.append(.init(name: "키워드추가"))
        return newKeywords
    }
}

// MARK: - Keyword
extension AnswerViewModel {
    
    /// 기존의 키워드를 추가합니다.
    func addKeyword(_ keyword: Keyword) {
        keywords.append(.init(name: keyword.name))
    }
    
    /// 추가한 키워드를 목록에서 삭제합니다.
    func removeKeyword(_ keyword: Keyword) {
        guard let index = flexKeywords.firstIndex(of: keyword) else { return }
        keywords.remove(at: index)
    }
    
    /// 검색어로 새로운 키워드를 생성합니다.
    func createNewKeyword(_ keyword: String) {
        keywords.append(.init(name: keyword))
    }
}
