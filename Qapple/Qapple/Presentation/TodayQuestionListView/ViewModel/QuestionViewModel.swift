import Foundation

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    
    @Published var filteredQuestions: [QuestionResponse.Questions.Content] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var selectedQuestionId: Int? = nil
    @Published var questions: [QuestionResponse.Questions.Content] = [] // 모든 질문의 목록입니다.
    
    @MainActor
    func fetchGetQuestions() async {
        do {
            let response = try await getQuestions()
            self.questions = response.content
            print(self.questions)
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// 질문 목록을 받아옵니다.
    func getQuestions() async throws -> QuestionResponse.Questions {
        
        // URL 생성
        let urlString = ApiEndpoints.basicURLString(path: .questions)
        guard let url = URL(string: urlString) else { fatalError("에러") }
        
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
        
        // 네트워크 통신
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
