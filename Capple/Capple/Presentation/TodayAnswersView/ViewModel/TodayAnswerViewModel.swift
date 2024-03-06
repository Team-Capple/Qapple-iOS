
//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation
import Combine

class TodayAnswersViewModel: ObservableObject {
    @Published var keywords: [String] = ["ALL", "쌀국수", "와플", "물", "아무고토", "없어요", "샐러드", "처갓집양념치킨"]
    @Published var todayQuestion: String = "가장 최근에 먹었던 음식 중 가장 인상깊었던 것은 무엇인가요?"
    @Published var answers: [Answer] = []
    @Published var filteredAnswer: [Answer] = []
    @Published var searchQuery = ""
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.
    
    private var cancellables: Set<AnyCancellable> = []
    private let questionId = 1 // 질문넘버
    
    init() {
        submitAnswer()
    }
    
    func testFetchData() {
        guard let url = URL(string: "http://43.203.126.187:8080/answers/question/\(questionId)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString) // 서버 응답 출력
                }
            }
        }.resume()
    }
    
    
    func submitAnswer() {
           guard let url = URL(string: "http://43.203.126.187:8080/answers/question/\(questionId)") else { return }
           do {
               URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                   DispatchQueue.main.async {
                       guard let self = self else { return }
                       if let error = error {
                           print("Error submitting answer: \(error)")
                           return
                       }
                       guard let data = data else {
                           print("No data in response")
                           return
                       }
                       do {
                           let decodedData = try JSONDecoder().decode(ServerResponse.self, from: data)
                              let newAnswers = decodedData.result.answerInfos
                              self.answers.append(contentsOf: newAnswers)
                       } catch {
                           print("Error decoding response: \(error)")
                       }
                   }
               }.resume()
           }
       }

    func loadMoreContentIfNeeded(currentIndex index: Int) {
        // 배열의 마지막에서 5번째 인덱스를 계산합니다.
        // 이 값은 더 많은 내용을 로드해야 하는 "임계 인덱스"가 됩니다.
        let thresholdIndex = answers.count - 10
        // 현재 인덱스가 임계 인덱스보다 크거나 같으면 추가 데이터를 로드합니다.
        if index >= thresholdIndex {
            submitAnswer()
        }
    }
}


/*
    func filterAnswers(with searchText : String) {
        print("\(searchText)")
        if searchText.isEmpty {
            filteredAnswer =  self.answers

        } else {
            filteredAnswer = self.answers.filter { answer in
                answer.nickname.localizedCaseInsensitiveContains(searchText) ||
                answer.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
*/
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

