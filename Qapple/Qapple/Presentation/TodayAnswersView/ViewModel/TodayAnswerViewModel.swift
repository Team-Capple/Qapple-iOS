
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
    
    /// 답변 호출 API입니다.
    func loadAnswersForQuestion(questionId: Int) {
        
        // URL 생성
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion)
        guard let url = URL(string: "\(urlString)/\(questionId)") else {
            print("유효하지 않은 URL")
            return
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        // Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
                        }
                    } catch {
                        print("ServerResponse.Answers - Error decoding response: \(error)")
                    }
                }
            }
            .resume()
        }
    }
}
