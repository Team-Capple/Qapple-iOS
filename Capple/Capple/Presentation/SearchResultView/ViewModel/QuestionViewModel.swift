//
//  QuestionViewModel.swift
//  Capple
//
//  Created by 심현희 Lee on 2/23/24.
//

import Foundation
import CoreData

class QuestionViewModel: ObservableObject {
    
    @Published var searchQuery = "" {
        didSet {
            filterQuestions()
        }
    }
    @Published var filteredQuestions: [Question] = [] // 필터링된 질문 목록
    
    @Published var questions: [Question] = []
    @Published var isLoading = false
    private var currentPage = 0
    private let pageSize = 10
    
    init() {
        loadMoreContent()
        // 원본 질문 목록을 로드하는 로직을 여기에 추가합니다.
        
        questions = []
        // ... 여기에 Question 객체들을 초기화하는 코드 ...
        
        filterQuestions() // 초기 필터링 실행
    }
    
    
    func loadMoreContentIfNeeded(currentItem item: Question?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = questions.index(questions.endIndex, offsetBy: -5)
        if questions.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    private func loadMoreContent() {
        guard !isLoading else { return }
        isLoading = true
        
        // Here you would load new content from a data source or API
        // For the sake of simplicity, we're just appending new questions
        let newQuestions = (1...30).map { i in
            Question(id: i, title: "Question \(i)", detail: "This is the detail for question \(i).", tags: ["Tag1", "Tag2"], likes: i, comments: i)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.questions.append(contentsOf: newQuestions)
            self.isLoading = false
        }
    }
    private func filterQuestions() {
        if searchQuery.isEmpty {
            filteredQuestions = questions // 검색어가 비어있다면 모든 질문을 보여줍니다.
        } else {
            filteredQuestions = questions.filter { question in
                // 대소문자를 구분하지 않고 검색어가 제목, 상세 내용, 태그 중 하나라도 포함되는지 확인합니다.
                question.title.localizedCaseInsensitiveContains(searchQuery) ||
                question.detail.localizedCaseInsensitiveContains(searchQuery) ||
                question.tags.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
            }
        }
    }
    
}
