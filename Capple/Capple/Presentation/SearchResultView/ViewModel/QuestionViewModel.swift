import Foundation

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    @Published var filteredQuestions: [QuestionResponse.Questions.QuestionsInfos] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var selectedQuestionId: Int? = nil
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.

    
    @MainActor
    func fetchGetQuestions() async {
        isLoading = true
        do {
            let response = try await getQuestions()
            self.questions = response.questionInfos ?? []
            print("테스트\(self.questions)")
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    /// 질문 목록을 받아옵니다.
    func getQuestions() async throws -> QuestionResponse.Questions {
        
        // URL 생성
        guard let url = URL(string: "http://43.203.126.187:8080/questions") else { fatalError("에러") }
        
        // Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SignInInfo.shared.accessToken())", forHTTPHeaderField: "Authorization")
        
        // 네트워크 통신
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // print(data)
        // print(response)
        
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode) {
            throw NetworkError.cannotCreateURL
        }
        
        let decoder = JSONDecoder()
        
        let jsonDictionary = try decoder.decode(BaseResponse<QuestionResponse.Questions>.self, from: data)
        
        var questions: QuestionResponse.Questions
        questions = jsonDictionary.result
        
        return questions
        
        //
        
        
        //        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        //  DispatchQueue.main.async {
        //                guard let self = self else { return }
        //
        //                // 에러 확인
        //                if let error = error {
        //                    print("Error submitting questions: \(error)")
        //                    return
        //                }
        //
        //                // MARK: - 상태코드확인 처리
        //                if let httpResponse = response as? HTTPURLResponse {
        //
        //                    // 상태 코드를 검사하여 다음 단계를 결정합니다.
        //                    switch httpResponse.statusCode {
        //                    case 200...299:
        //                        // 성공적인 응답 처리
        //                        if data != nil {
        //                            // 데이터 처리
        //                        }
        //                    default:
        //                        // 다른 상태 코드 처리
        //                        print("Received HTTP \(httpResponse.statusCode)")
        //                    }
        //                }
        //
        //                // MARK: - 데이터처리
        //                guard let data = data else {
        //
        //                    print("No data in response")
        //                    return
        //                }
        //            let decodedData = try JSONDecoder().decode(BaseResponse<QuestionResponse.Questions>.self, from: data)
        //
        //                self.questions = decodedData.result.questionInfos ?? []
        //                print(self.questions ?? "데이터 오류", "데이터가 정말 잘 업데이트 ! 되고 있습니다!! ")
        //
        //  }
        //        }.resume()
    }
}

extension QuestionViewModel {
    func contentForQuestion(withId id: Int?) -> String? {
        guard let id = id,
              let content = questions.first(where: {
                  $0.questionId == id
              })?.content else {
            return "Question ViewModel 에서의 디폴트 스트링"
        }
        
        return content
    }
}
