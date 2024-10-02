
//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation

class AnswerListViewModel: ObservableObject {
    
    /// Key: writerId
    /// Value: Index
    typealias LearnerDictionary = [Int: Int]
    
    @Published var keywords: [String] = []
    @Published var todayQuestion: String = ""
    @Published var answerList: [AnswerResponse.AnswersOfQuestion.Content] = []
    @Published var isLoading = true
    @Published var pageNumber: Int = 0
    @Published var hasPrevious: Bool = false
    @Published var hasNext: Bool = false
    @Published var threshold: Int?
    
    private var learnerDictionary: LearnerDictionary = [:]
    
    /// 답변 호출 API입니다.
    @MainActor
    func loadAnswersForQuestion(questionId: Int) {
        Task {
            do {
                let response = try await NetworkManager.fetchAnswersOfQuestion(
                    request: .init(
                        questionId: questionId,
                        threshold: threshold,
                        pageNumber: pageNumber,
                        pageSize: 25
                    )
                )
                
                let newAnswerList = response.content.reversed()
                self.answerList += newAnswerList
                self.pageNumber += 1
                self.threshold = Int(response.threshold)
                self.hasPrevious = response.hasPrevious
                self.hasNext = response.hasNext
                createLearnerDictionary()
            } catch {
                print("답변 리스트 호출 실패")
            }
            self.isLoading = false
        }
    }
    
    /// 답변 리프레쉬 API입니다.
    @MainActor
    func refreshAnswersForQuestion(questionId: Int) {
        
        // 초기화
        self.pageNumber = 0
        self.hasPrevious = false
        self.hasNext = false
        
        Task {
            do {
                let response = try await NetworkManager.fetchAnswersOfQuestion(
                    request: .init(
                        questionId: questionId,
                        threshold: threshold,
                        pageNumber: pageNumber,
                        pageSize: 25
                    )
                )
                
                self.answerList.removeAll()
                let newAnswerList = response.content.reversed()
                self.answerList += newAnswerList
                self.pageNumber += 1
                self.threshold = Int(response.threshold)
                self.hasPrevious = response.hasPrevious
                self.hasNext = response.hasNext
                createLearnerDictionary()
            } catch {
                print("답변 리스트 호출 실패")
            }
            self.isLoading = false
        }
    }
}

// MARK: - 러너 인덱스

extension AnswerListViewModel {
    
    /// 러너 인덱스를 반환합니다.
    func learnerIndex(to answer: AnswerResponse.AnswersOfQuestion.Content) -> Int {
        if let index = learnerDictionary[answer.writerId] {
            return index
        } else {
            return 0
        }
    }
    
    /// 러너 인덱스가 담긴 Dictionary를 생성합니다.
    private func createLearnerDictionary() {
        for (index, answer) in self.answerList.enumerated() {
            learnerDictionary.updateValue(index, forKey: answer.writerId)
        }
    }
}
