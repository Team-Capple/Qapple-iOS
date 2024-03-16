import Foundation
import Combine

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    @Published var filteredQuestions: [QuestionResponse.Questions.QuestionsInfos] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    @Published var selectedQuestionId: Int? = nil
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.
    @Published var searchQuery = ""
   
    private var authViewModel: AuthViewModel?

       // AuthViewModel을 매개변수로 받는 초기화 메서드 추가
    init(authViewModel: AuthViewModel) {
           self.authViewModel = authViewModel
        updateQuestions(using: authViewModel)
           getQuestions(accessToken: "eyJhbGciOiJIUzUxMiJ9.eyJ0b2tlblR5cGUiOiJhY2Nlc3MiLCJtZW1iZXJJZCI6NCwicm9sZSI6IlJPTEVfQUNBREVNSUVSIiwiaWF0IjoxNzEwNTg4NzI2LCJleHAiOjE3MTE0NTI3MjZ9.AL0jYCqf-SbrVeBNHN87QEEz7oDQBOltVOrsoObVRKK54qt0YVM0xZQObXAKDo0go6bno6h8O0zlnSJmiei5kg" )
       }
       
    
    // searchQuery의 변경을 감지하고 필터링을 수행합니다.
    // private var cancellables: Set<AnyCancellable> = []

  //  @Published var accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJ0b2tlblR5cGUiOiJhY2Nlc3MiLCJtZW1iZXJJZCI6NCwicm9sZSI6IlJPTEVfQUNBREVNSUVSIiwiaWF0IjoxNzEwNTg4NzI2LCJleHAiOjE3MTE0NTI3MjZ9.AL0jYCqf-SbrVeBNHN87QEEz7oDQBOltVOrsoObVRKK54qt0YVM0xZQObXAKDo0go6bno6h8O0zlnSJmiei5kg"
    func updateQuestions(using authViewModel: AuthViewModel) {
           guard let accessToken = authViewModel.signInResponse.accessToken else { return }
           
           // 이제 accessToken을 사용하여 질문을 불러올 수 있습니다.
           getQuestions(accessToken: accessToken)
       
       }

    func getQuestions(accessToken: String) {
        
        guard let url = URL(string: "http://43.203.126.187:8080/questions") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
              //  request.setValue("Bearer \(String(describing: AuthViewModel))", forHTTPHeaderField: "Authorization")

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
    /*
    func loadMoreContentIfNeeded(currentIndex index: Int) {
        // 배열의 마지막에서 5번째 인덱스를 계산합니다.
        // 이 값은 더 많은 내용을 로드해야 하는 "임계 인덱스"가 됩니다.
        let thresholdIndex = questions.count - 10
        // 현재 인덱스가 임계 인덱스보다 크거나 같으면 추가 데이터를 로드합니다.
        if index >= thresholdIndex {
            getQuestions(accessToken: accessToken)
        }
    }
    */
    // MARK: - 좋아요
    /*
    func likeButtonTapped(for question: QuestionResponse.Questions.QuestionsInfos) {
           guard questions.firstIndex(where: { $0.id == question.id }) != nil else { return }
           // 해당 질문의 likeCount 증가
           guard var likes = question.likeCount else { return }
           likes += 1
       }
    */
    // MARK: - 필터링
    /*
    // 검색 쿼리에 따라 질문 목록을 필터링합니다.
    func filterQuestions(with searchText : String) {
        print("\(searchText)")
        if searchText.isEmpty {
            filteredQuestions =  self.questions
        } else {
            filteredQuestions = self.questions.filter { question in
                if let content = question.self {
                    return content.contains(searchText)
                } else {
                    return false
                }
            }
        }
    }
     */
    /*
   func initiate(with searchText : String) {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] searchText in
                       self?.filteredQuestions = self?.filterQuestions(with: searchText) ?? []
                   })
            .store(in: &cancellables)
    }
  */
}

