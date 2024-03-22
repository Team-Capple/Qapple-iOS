
//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation

class TodayAnswersViewModel: ObservableObject {
    
    @Published var keywords: [String] = []
    @Published var todayQuestion: String = ""
    @Published var answers: [ServerResponse.Answers.AnswersInfos] = []
    @Published var filteredAnswer: [ServerResponse.Answers.AnswersInfos] = []
    @Published var searchQuery = ""
    @Published var isLoading = false
    @Published var questionId: Int?
   
    init(questionId: Int) {
        self.questionId = questionId
        loadAnswersForQuestion()
    }
    
    func loadAnswersForQuestion() {
        
        // 질문 ID 검사
        guard let questionId = self.questionId else {
            print("유효하지 않은 질문 ID")
            return
        }
        
        // URL 생성
        guard let url = URL(string: "http://43.203.126.187:8080/answers/question/\(questionId)") else {
            print("유효하지 않은 URL")
            return
        }
        
        // Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SignInInfo.shared.accessToken())", forHTTPHeaderField: "Authorization")
        
        // URLSession 실행
        do {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    // 에러 검사
                    if let error = error {
                        print("Error submitting answer: \(error)")
                        return
                    }
                    
                    // 데이터 검사
                    guard let data = data else {
                        print("No data in response")
                        return
                    }
                    
                    // Decoding
                    do {
                        let decodedData = try JSONDecoder().decode(BaseResponse<ServerResponse.Answers>.self, from: data)
                        DispatchQueue.main.async {
                            self.answers = decodedData.result.answerInfos
                            print("Decoded data: \(self.answers)")
                        }
                    } catch {
                        print("ServerResponse.Answers - Error decoding response: \(error)")
                    }
                }
            }
            .resume()
        }
    }

    func loadMoreContentIfNeeded(currentIndex index: Int) {
        // 배열의 마지막에서 5번째 인덱스를 계산합니다.
        // 이 값은 더 많은 내용을 로드해야 하는 "임계 인덱스"가 됩니다.
        let thresholdIndex = answers.count
        // 현재 인덱스가 임계 인덱스보다 크거나 같으면 추가 데이터를 로드합니다.
        if index >= thresholdIndex {
            loadAnswersForQuestion()
            print("reload 됩니다")
        }
    }
}
