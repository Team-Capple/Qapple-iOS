import Foundation

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    @Published var filteredQuestions: [QuestionResponse.Questions.QuestionsInfos] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var selectedQuestionId: Int? = nil
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.
    @Published var searchQuery = ""
    let accessToken = SignInInfo.shared.accessToken()
    
    init() {
        print("뷰모델 생성")
        getQuestions(accessToken: accessToken)
    }
    
    /// 질문 목록을 받아옵니다.
    func getQuestions(accessToken: String) {
        guard let url = URL(string: "http://43.203.126.187:8080/questions") else { return }
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
                        // print("Decoded data: \(self.questions)")
                    }
                } catch {
                    print("Error decoding question response: \(error)")
                }
            }
        }.resume()
    }
}

extension QuestionViewModel {
    func contentForQuestion(withId id: Int?) -> String? {
        guard let id = id else { return "string" }
        print(id, "QuestionViewModel에서 ID가 들어옵니다")
        print(questions.first {$0.questionId == id }?.content!,"QuestionViewModel에서의 questions.first값")
        guard let content = questions.first { $0.questionId == id }?.content else { return "Question ViewModel 에서의 디폴트 스트링" }
        print(content)
        return content
        
    }
}
