//
//  TodayQuestionViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

final class TodayQuestionViewModel: ObservableObject {
    
    /// Key: writerId
    /// Value: Index
    typealias LearnerDictionary = [Int: Int]
    
    let dateManager = QuestionTimeManager()
    var timer: Timer?
    
    @Published var remainingTime = TimeInterval()
    @Published var timeZone: QuestionTimeZone
    @Published var state: QuestionState?
    @Published var mainQuestion: QuestionResponse.MainQuestion
    @Published var answerList: [AnswerResponse.AnswersOfQuestion.Content]
    @Published var isLoading = true
    
    private var learnerDictionary: LearnerDictionary = [:]
    
    init() {
        let currentTimeZone = dateManager.fetchTimezone()
        self.timeZone = currentTimeZone
        
        // 변수 초기화
        self.mainQuestion = .init(
            questionId: 0,
            questionStatus: "",
            content: "",
            isAnswered: false
        )
        
        self.answerList = []
    }
}

// MARK: - 러너 인덱스

extension TodayQuestionViewModel {
    
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

// MARK: - 현재 상태 업데이트
extension TodayQuestionViewModel {
    
    /// 리프레쉬를 위해 전체 뷰를 업데이트합니다.
    @MainActor
    func updateTodayQuestionView() {
        Task {
            await requestMainQuestion()
            await requestAnswerPreview()
            updateQuestionState()
            isLoading = false
        }
    }
    
    /// 현재 시간 및 답변 상태에 따라 QuestionState를 업데이트합니다.
    @MainActor
    func updateQuestionState() {
        let currentTimeZone = dateManager.fetchTimezone()
        self.timeZone = currentTimeZone
        
        // 타이머 시작 로직
        if timeZone == .amCreate || timeZone == .pmCreate {
            startTimer()
        }
        
        if currentTimeZone == .am || currentTimeZone == .pm {
            self.state = mainQuestion.isAnswered ? .complete : .ready
        } else {
            self.state = .creating
        }
    }
}

// MARK: - 질문 업데이트
extension TodayQuestionViewModel {
    
    /// 오늘의 메인 질문을 요청하고 업데이트합니다.
    @MainActor
    func requestMainQuestion() async {
        do {
            let mainQuestion = try await NetworkManager.fetchMainQuestion()
            print(mainQuestion)
            self.mainQuestion = mainQuestion
            print("메인 질문 ID:\(mainQuestion.questionId)")
        } catch {
            print("메인 질문 업데이트 실패")
        }
    }
}

// MARK: - 답변 업데이트
extension TodayQuestionViewModel {
    
    /// 메인 질문의 답변 프리뷰(3개)를 요청하고 업데이트합니다.
    @MainActor
    func requestAnswerPreview() async {
        do {
            let answerPreview = try await NetworkManager.fetchAnswersOfQuestion(
                request: .init(
                    questionId: self.mainQuestion.questionId,
                    pageNumber: 0,
                    pageSize: 1000
                ))
            let answerList = Array(answerPreview.content.prefix(3))
            self.answerList = answerList.reversed()
            createLearnerDictionary()
        } catch {
            print("답변 프리뷰 업데이트 실패")
        }
    }
}

// MARK: - 텍스트
extension TodayQuestionViewModel {
    
    /// 질문 타이틀 텍스트를 반환합니다.
    var titleText: String {
        var text = ""
        if state == .creating { text = "오늘의 질문을 만들고 있어요" }
        else if state == .ready { text = "오늘의 질문이\n준비되었어요!" }
        else if state == .complete { text = "오늘의 답변을\n완료했어요!" }
        return text
    }
    
    /// 버튼 텍스트를 반환합니다.
    var buttonText: String {
        var text = ""
        if state == .creating {
            if mainQuestion.isAnswered {
                text = "이전 답변 둘러보기"
            } else {
                text = "이전 질문 답변하기"
            }
        }
        else if state == .ready { text = "질문에 답변하기" }
        else if state == .complete { text = "다른 답변 둘러보기" }
        return text
    }
    
    /// 버튼 컬러를 반환합니다.
    var buttonColor: Color {
        var color = Color.black
        if state == .creating {
            if mainQuestion.isAnswered {
                color = GrayScale.secondaryButton
            } else {
                color = BrandPink.button
            }
        }
        else if state == .ready { color = BrandPink.button }
        else if state == .complete { color = GrayScale.secondaryButton }
        return color
    }
    
    /// 리스트 타이틀 텍스트를 반환합니다.
    var listTitleText: AttributedString {
        let mainQuestionText = AttributedString(mainQuestion.content)
        
        return mainQuestionText
    }
    
    /// 리스트 서브 타이틀 텍스트를 반환합니다.
    var listSubText: String {
        var text = ""
        if state == .creating { text = "답변 미리보기" }
        else if state == .ready { text = "답변 미리보기" }
        else if state == .complete { text = "답변 미리보기" }
        return text
    }
}

// MARK: - 시간 관련
extension TodayQuestionViewModel {
    
    /// 타이머를 실행합니다.
    @MainActor
    func startTimer() {
        timer?.invalidate()
        
        if timeZone == .amCreate {
            let calendar = Calendar.current
            let now = Date()
            
            var components = DateComponents()
            components.hour = 7
            components.minute = 0
            components.second = 5
            
            let am = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
            self.remainingTime = am.timeIntervalSinceNow
        }
        
        else if timeZone == .pmCreate {
            let calendar = Calendar.current
            let now = Date()
            
            var components = DateComponents()
            components.hour = 18
            components.minute = 0
            components.second = 5
            
            let pm = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
            self.remainingTime = pm.timeIntervalSinceNow
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            remainingTime -= 1
            
            // 시간이 음수가 되면 타이머 중지 후 QuestionTimeZone 업데이트
            if remainingTime <= 0 {
                timer.invalidate()
                updateTodayQuestionView()
            }
        }
    }
    
    /// TimeInterval 타입을 스트링 타이머 포맷으로 반환합니다.
    func timeString() -> String {
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
