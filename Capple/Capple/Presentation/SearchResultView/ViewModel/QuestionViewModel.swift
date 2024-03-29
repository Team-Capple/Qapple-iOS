import Foundation

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    
    @Published var filteredQuestions: [QuestionResponse.Questions.QuestionsInfos] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var selectedQuestionId: Int? = nil
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.

    
    @MainActor
    func fetchGetQuestions() async {
        do {
            let response = try await getQuestions()
            self.questions = response.questionInfos ?? []
        } catch {
            print("Error: \(error)")
        }
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
