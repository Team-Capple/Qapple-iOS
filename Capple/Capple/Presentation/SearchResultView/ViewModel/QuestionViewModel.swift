import Foundation
import Combine

// 질문 데이터를 관리하는 ViewModel
class QuestionViewModel: ObservableObject {
    @Published var filteredQuestions: [Question] = [] // 검색 쿼리에 따라 필터링된 질문 목록입니다.
    
    @Published var questions: [Question] = [] // 모든 질문의 목록입니다.
    @Published var isLoading = false // 데이터 로딩 중인지 여부를 나타냅니다.
    
    @Published var questionMockDatas: [Question] = [
        .init(
            id: 0,
            timeZone: .am,
            date: Date(),
            state: .complete,
            title: "오전 질문에 답변 후\n모든 내용을 확인해보세요",
            keywords: [.init(name: "무자비"), .init(name: "당근맨"), .init(name: "와플대학")],
            likes: 38,
            comments: 185
        ),
        
        .init(
            id: 1,
            timeZone: .am,
            date: Date(),
            state: .complete,
            title: "오전 질문에 답변 후\n모든 내용을 확인해보세요",
            keywords: [.init(name: "무자비"), .init(name: "당근맨"), .init(name: "와플대학")],
            likes: 38,
            comments: 185
        ),
    
        .init(
            id: 2,
            timeZone: .am,
            date: Date(),
            state: .complete,
            title: "오전 질문에 답변 후\n모든 내용을 확인해보세요",
            keywords: [.init(name: "무자비"), .init(name: "당근맨"), .init(name: "와플대학")],
            likes: 38,
            comments: 185
        )
    ]
    
    private var currentPage = 0 // 현재 로드된 페이지 번호입니다.
    private let pageSize = 15 // 한 번에 로드할 데이터의 양입니다.
    
    @Published var searchQuery = ""

    // searchQuery의 변경을 감지하고 필터링을 수행합니다.
    // private var cancellables: Set<AnyCancellable> = []

    init() {
        loadMoreContent() // 초기 데이터 로딩

    }
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
    
    // 검색 쿼리에 따라 질문 목록을 필터링합니다.
    func filterQuestions(with searchText : String) {
        print("\(searchText)")
        if searchText.isEmpty {
            filteredQuestions =  self.questions

        } else {
            filteredQuestions = self.questions.filter { question in
                question.title.localizedCaseInsensitiveContains(searchText) ||
                // question.detail.localizedCaseInsensitiveContains(searchText) ||
                question.keywords.contains(where: { $0.name.localizedCaseInsensitiveContains(searchText) })
            }
        }


    }
    
 /*   func initiate(with searchText : String) {
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
       loadMoreContent()
    }
}
