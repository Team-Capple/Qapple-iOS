import Foundation
import CoreData

class QuestionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    private var currentPage = 0
    private let pageSize = 10

    init() {
        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem item: Question?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = questions.index(questions.endIndex, offsetBy: -5)
        if questions.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    private func loadMoreContent() {
        guard !isLoading else { return }
        isLoading = true

        // Here you would load new content from a data source or API
        // For the sake of simplicity, we're just appending new questions
        let newQuestions = (1...30).map { i in
            Question(id: i, title: "Question \(i)", detail: "This is the detail for question \(i).", tags: ["Tag1", "Tag2"], likes: i, comments: i)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.questions.append(contentsOf: newQuestions)
            self.isLoading = false
        }
    }
}

