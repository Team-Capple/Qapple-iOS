import Foundation



class QuestionService {
    static let shared = QuestionService()
    @Published var questions: [QuestionResponse.Questions.QuestionsInfos] = [] // 모든 질문의 목록입니다.
  //  @Published var questionId: Int = 1
    private init() {
       
    }

  
}
