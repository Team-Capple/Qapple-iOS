//
//  AnswerViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import Foundation

final class AnswerViewModel: ObservableObject {
    
    @Published var answer: String
    @Published var search: String
    
    @Published var keywords: [Keyword]
    @Published var keywordPreviews: [Keyword]
    
    var questionId = 0
    var questionContent = ""
    
    let textLimited = 250
    
    init() {
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
    }
    
    /// 답변을 위해 작성한 양식을 모두 초기화합니다.
    func resetAnswerInfo() {
        answer.removeAll()
        search.removeAll()
        keywords.removeAll()
    }
}

// MARK: - 답변 등록
extension AnswerViewModel {
    
    @MainActor
    func requestRegisterAnswer() async throws {
        do {
            print("답변 등록을 시도할 질문 ID: \(questionId)")
            let _ = try await NetworkManager.requestRegisterAnswer(
                request: .init(answer: answer, tags: keywords.map { $0.name }),
                questionID: questionId
            )
            print("답변 등록 성공!")
        } catch {
            print("답변 등록 실패,,,")
        }
    }
}

// MARK: - Text
extension AnswerViewModel {
    
    /// 질문 텍스트를 반환합니다.
    func questionText(_ text: String) -> AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        let attributeText = AttributedString(stringLiteral: text)
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
