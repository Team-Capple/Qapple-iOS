
//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation

/*
class TodayAnswerViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    // 데이터를 로드하는 메소드
    func loadPosts() {
        // 여기서 실제 데이터를 로드하는 로직을 구현합니다.
        // 예제를 위해 임시 데이터를 생성합니다.
        posts = [
            Post(title: "첫 번째 포스트", content: "첫 번째 포스트의 내용입니다.", likes: 32),
            // 더 많은 포스트를 추가할 수 있습니다.
        ]
    }
}
*/
/*
// 뷰모델은 UI에 표시될 데이터와 로직을 관리합니다.
class TodayAnswersViewModel: ObservableObject {
    // 키워드 배열을 관리하는 프로퍼티입니다. 실제 앱에서는 서버나 데이터베이스에서 가져올 수 있습니다.
    @Published var keywords: [String] = ["ALL", "쌀국수", "와플", "물", "아무고토"]
    
    // 오늘의 질문을 관리하는 프로퍼티입니다. 이것도 실제 앱에서는 변경될 수 있습니다.
    @Published var todayQuestion: String = "가장 최근에 먹었던 음식 중 가장 인상깊었던 것은 무엇인가요?"
    
    // 질문에 대한 답변들을 관리하는 프로퍼티입니다. 실제 앱에서는 사용자의 입력을 받아 업데이트 될 수 있습니다.
    @Published var answers: [String] = ["답변 1", "답변 2", "답변 3"] // 예시 답변입니다.
    
    // 초기화 함수입니다. 필요한 데이터를 불러오는 등의 초기 작업을 수행할 수 있습니다.
    init() {
        // 데이터 로딩 로직을 여기에 추가할 수 있습니다.
    }
}
*/
import Foundation

class TodayAnswersViewModel: ObservableObject {
    @Published var keywords: [String] = ["ALL", "쌀국수", "와플", "물", "아무고토", "없어요", "샐러드", "처갓집양념치킨"]
    @Published var todayQuestion: String = "가장 최근에 먹었던 음식 중 가장 인상깊었던 것은 무엇인가요?"
    @Published var answers: [SingleAnswer] = []
    @Published var filteredAnswer: [SingleAnswer] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var searchQuery = ""
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.
    
    
    private var currentPage = 0 // 현재 로드된 페이지 번호입니다.
    private let pageSize = 15 // 한 번에 로드할 데이터의 양입니다.
    
    init() {
        loadMoreAnswers() // 초기 데이터 로딩

    }
    
    func loadMoreAnswers() {
        // 여기서 더 많은 답변들을 로드하는 로직을 구현합니다.
        // 예시로, 기존 답변들을 복사하여 추가합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            let newAnswers = (1...10).map { i in
                SingleAnswer(id: self.currentPage * self.pageSize + i, name: "Name \((self.currentPage * self.pageSize) + i)", content: "Description Answer \(i) is This", tags: ["Tag\(i)", "Tag\(i * 2)"], likes: i * 2 )
            }
            self.answers.append(contentsOf: newAnswers )
            self.filterQuestions(with: searchQuery)
            self.isLoading = false
            self.currentPage += 1
        }
    }
    func loadMoreContentIfNeeded(currentItem item: SingleAnswer?) {
        guard let item = item, !isLoading else { return }
        
        let thresholdIndex = answers.index(answers.endIndex, offsetBy: -5)
        if let itemIndex = answers.firstIndex(where: { $0.id == item.id }), itemIndex >= thresholdIndex {
            loadMoreAnswers()
        }
    }
    func filterQuestions(with searchText : String) {
        print("\(searchText)")
        if searchText.isEmpty {
            filteredAnswer =  self.answers

        } else {
            filteredAnswer = self.answers.filter { answer in
                answer.name.localizedCaseInsensitiveContains(searchText) ||
                answer.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
    }
}

// MARK: - 텍스트 반환
extension TodayAnswersViewModel {
    
    /// 오늘의 질문 텍스트를 반환합니다.
    var todayQuestionText: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        let creatingText = AttributedString("\(todayQuestion)")
        return questionMark + creatingText
    }
}

