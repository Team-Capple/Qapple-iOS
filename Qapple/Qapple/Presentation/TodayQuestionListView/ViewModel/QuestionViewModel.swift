import Foundation

// 질문 데이터를 관리하는 ViewModel
final class QuestionViewModel: ObservableObject {
    
    @Published var filteredQuestions: [QuestionResponse.Questions.Content] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var selectedQuestionId: Int? = nil
    @Published var questions: [QuestionResponse.Questions.Content] = [] // 모든 질문의 목록입니다.
    @Published var isLoading = true
    
    @Published var total = 0
    @Published var threshold: String?
    @Published var hasNext: Bool = false
    
    @MainActor
    func fetchGetQuestions() async {
        do {
            let response = try await getQuestions(
                threshold: threshold,
                pageSize: 25
            )
            
            self.questions += response.content
            self.total = response.total
            self.threshold = response.threshold
            self.hasNext = response.hasNext
            print("다음 질문 있냐? : \(self.hasNext)")
            self.isLoading = false
        } catch {
            print("Error: \(error)")
        }
    }
    
    @MainActor
    func refreshGetQuestions() async {
        self.hasNext = false
        
        do {
            let response = try await getQuestions(
                threshold: nil,
                pageSize: 25
            )
            
            self.questions.removeAll()
            self.questions += response.content
            self.total = response.total
            self.threshold = response.threshold
            self.hasNext = response.hasNext
            self.isLoading = false
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// 질문 목록을 받아옵니다.
    func getQuestions(threshold: String?, pageSize: Int) async throws -> QuestionResponse.Questions {
        
        let urlString = ApiEndpoints.basicURLString(path: .questions)
        guard let url = URL(string: urlString) else {
            throw NetworkError.cannotCreateURL
        }
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if let threshold = threshold,
           let encodedThreshold = threshold.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlComponent.queryItems = [
                .init(name: "threshold", value: encodedThreshold),
                .init(name: "pageSize", value: String(pageSize))
            ]
        } else {
            urlComponent.queryItems = [
                .init(name: "pageSize", value: String(pageSize))
            ]
        }
        
        guard let url = urlComponent.url else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
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
