import Foundation



class QuestionService {
    static let shared = QuestionService()
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.
    @Published var questionId: Int = 1
    private init() {
       
    }

    // 특정 ID를 가진 질문의 내용을 반환합니다.
    func getContent(withId id: Int) -> String {
        if let content = questions.first(where: {$0.questionId == self.questionId })?.content {
            return content
        }
        else {
            return "default"
        }
    }
    
    func contentForQuestion(completion: @escaping (String?) -> Void) -> String {
        // 이미 로드된 질문 목록에서 해당 ID를 가진 질문을 찾습니다.
       
        print(questionId, "contentForQuestion 아이디입니다")
        if let content = questions.first(where: {$0.questionId == self.questionId })?.content {
            completion(content)
            return content
        } else {
            // 해당 ID를 가진 질문이 목록에 없다면, 서버에서 질문 목록을 새로 불러옵니다.
            loadQuestions { [weak self] in
                completion(self?.questions.first(where: {$0.questionId == self?.questionId})?.content)
            }
            return "loadmore"
        }
    }
    func updateQuestion(withId id: Int) {
        // questions 배열 내에서 해당 ID를 가진 질문을 찾습니다.
        self.questionId = id
    }

    // 서버에서 질문 목록을 불러옵니다.
    func loadQuestions(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://43.203.126.187:8080/questions") else { return }
        var accessToken: String = "eyJhbGciOiJIUzUxMiJ9.eyJ0b2tlblR5cGUiOiJhY2Nlc3MiLCJtZW1iZXJJZCI6NCwicm9sZSI6IlJPTEVfQUNBREVNSUVSIiwiaWF0IjoxNzEwNTg4NzI2LCJleHAiOjE3MTE0NTI3MjZ9.AL0jYCqf-SbrVeBNHN87QEEz7oDQBOltVOrsoObVRKK54qt0YVM0xZQObXAKDo0go6bno6h8O0zlnSJmiei5kg"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    print("Error submitting questions: \(error)")
                    return
                }
                
                // MARK: - 상태코드확인 처리
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                    // 상태 코드를 검사하여 다음 단계를 결정합니다.
                    switch httpResponse.statusCode {
                    case 200...299:
                        // 성공적인 응답 처리
                        if data != nil {
                            // 데이터 처리
                        }
                    default:
                        // 다른 상태 코드 처리
                        print("Received HTTP \(httpResponse.statusCode)")
                    }
                }
                    
                    // MARK: - 데이터처리
                guard let data = data else {
                    
                    print("No data in response")
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(BaseResponse<QuestionResponse.Questions>.self, from: data)
                    DispatchQueue.main.async {
                        self.questions = decodedData.result.questionInfos ?? []
                               print("Decoded data: \(self.questions)")
                   
                    //    self.questions.append(contentsOf: self.questions)
                        
                      
                    }
                } catch {
                    print("Error decoding question response: \(error)")
                }               }
        }.resume()
    }
}
