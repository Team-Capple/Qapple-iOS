import Foundation
import Combine

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    @Published var filteredQuestions: [QuestionResponse.Questions.QuestionsInfos] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.
    
    
    
    // MARK: - 타임존 코드 
    /*
    var timeZoneFormatted: String {
           if let timeZone = questions.first?.timeZone {
               return timeZone == "am" ? "오전 질문" : "오후 질문"
           } else {
               return "오전 질문" // 기본값 설정
           }
       }
    */
    
    @Published var searchQuery = ""

    // searchQuery의 변경을 감지하고 필터링을 수행합니다.
    // private var cancellables: Set<AnyCancellable> = []

    init() {
        getQuestions() // 초기 데이터 로딩

    }
    
    
    func getQuestions() {
           guard let url = URL(string: "http://43.203.126.187:8080/questions") else { return }
        print("start")
           URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
                           self.questions.append(contentsOf: self.questions)
                         
                       }
                   } catch {
                       print("Error decoding response: \(error)")
                   }               }
           }.resume()
       }
    func loadMoreContentIfNeeded(currentIndex index: Int) {
        // 배열의 마지막에서 5번째 인덱스를 계산합니다.
        // 이 값은 더 많은 내용을 로드해야 하는 "임계 인덱스"가 됩니다.
        let thresholdIndex = questions.count - 10
        // 현재 인덱스가 임계 인덱스보다 크거나 같으면 추가 데이터를 로드합니다.
        if index >= thresholdIndex {
            getQuestions()
        }
    }


    
// MARK: - 이전코드
    /*
    
    // 필요에 따라 추가 콘텐츠를 로드합니다.
    func loadMoreContentIfNeeded(currentItem item: Question?) {
        guard let item = item, !isLoading else { return }
        
        let thresholdIndex = questions.index(questions.endIndex, offsetBy: -5)
        if let itemIndex = questions.firstIndex(where: { $0.id == item.id }), itemIndex >= thresholdIndex {
            loadMoreContent()
        }
    }
    
    // 실제로 새로운 콘텐츠를 로드하는 메소드입니다.
    func loadMoreContent() {
        guard !isLoading else { return }
        isLoading = true
        
        // 새로운 질문들을 로드하는 로직을 구현합니다.
        // 예시로, 임시 데이터를 생성하여 추가합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            let newQuestions = (1...10).map { i in
                Question(
                    id: 0,
                    timeZone: .am,
                    date: Date(),
                    state: .complete,
                    title: "오전 질문에 답변 후 모든 내용을 확인해보세요",
                    keywords: [.init(name: "무자비"), .init(name: "당근맨"), .init(name: "와플대학")],
                    likes: 38,
                    comments: 185
                )
//                Question(id: self.currentPage * self.pageSize + i, title: "Question \((self.currentPage * self.pageSize) + i)", detail: "This is the detail for question \((self.currentPage * self.pageSize) + i).", tags: ["Tag\(i)", "Tag\(i * 2)"], likes: i * 2, comments: i * 3)
            }
            self.questions.append(contentsOf: newQuestions )
            self.filterQuestions(with: searchQuery)
            self.isLoading = false
            self.currentPage += 1
        }
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

extension QuestionViewModel {
    func reloadQuestions() {
       getQuestions()
    }
}
