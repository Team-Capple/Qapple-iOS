//
//  TodayQuestionViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import Foundation

final class TodayQuestionViewModel: ObservableObject {
    
    let dateManager = QuestionTimeManager()
    
    @Published var timeZone: QuestionTimeZone
    @Published var state: QuestionState
    @Published var timerSeconds: String
    
    var timer: Timer?
    
    @Published var mainQuestion: QuestionResponse.MainQuestion
    @Published var answerList: [AnswerResponse.AnswersOfQuestion.AnswerInfos]
    
    init() {
        let currentTimeZone = dateManager.fetchTimezone()
        self.timeZone = currentTimeZone
        self.timerSeconds = dateManager.fetchTimerSeconds(currentTimeZone)
        
        if currentTimeZone == .am || currentTimeZone == .pm {
            // TODO: - 답변 작성 전 = ready, 답변 작성 후 = complete
            self.state = .ready
        } else {
            self.state = .creating
        }
        
        // 변수 초기화
        self.mainQuestion = .init(questionId: 0, questionStatus: "", content: "", isAnswered: false)
        self.answerList = []
        
        Task {
            await requestMainQuestion()
            await requestAnswerPreview()
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
            self.mainQuestion = mainQuestion
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
                    keyword: nil,
                    size: 3
                ))
            self.answerList = answerPreview.answerInfos
        } catch {
            print("답변 프리뷰 업데이트 실패")
        }
    }
}

// MARK: - 텍스트
extension TodayQuestionViewModel {
    
    /// 질문 타이틀 텍스트를 반환합니다.
    var titleText: String {
        var text = "질문 타이틀"
        if timeZone == .amCreate { text = "오전 질문을 만들고 있어요" }
        else if timeZone == .pmCreate { text = "오후 질문을 만들고 있어요" }
        else if state == .ready { text = "\(timeZone.rawValue) 질문이\n준비되었어요!" }
        else if state == .complete { text = "\(timeZone.rawValue) 답변을\n완료했어요!" }
        return text
    }
    
    /// 버튼 텍스트를 반환합니다.
    var buttonText: String {
        var text = "버튼 타이틀"
        if state == .creating { text = "이전 질문 보러가기" }
        else if state == .ready { text = "질문에 답변하기" }
        else if state == .complete { text = "다른 답변 둘러보기" }
        return text
    }
    
    /// 리스트 타이틀 텍스트를 반환합니다.
    var listTitleText: AttributedString {
        
        // Q. Mark
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        
        let mainQuestionText = AttributedString(mainQuestion.content)
        
        var text = AttributedString()
        if state == .creating { text = questionMark + mainQuestionText }
        else if state == .ready { text = "어떤 질문이 나왔을까요?" }
        else if state == .complete { text = questionMark + mainQuestionText }
        return text
    }
    
    /// 리스트 서브 타이틀 텍스트를 반환합니다.
    var listSubText: String {
        var text = "리스트 서브 타이틀"
        if state == .creating { text = "최근에 달린 답변" }
        else if state == .ready { text = "답변 미리보기" }
        else if state == .complete { text = "실시간 답변 현황" }
        return text
    }
}

// MARK: - Method
extension TodayQuestionViewModel {
    
    /// 현재 시간에 맞춰 질문 시간을 업데이트합니다.
    func updateTimeZone() {
        timeZone = dateManager.fetchTimezone()
    }
    
    /// 타이머를 실행합니다.
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            timerSeconds = dateManager.fetchTimerSeconds(timeZone)
        }
    }
    
    /// 타이머를 초기화합니다.
    func stopTimer() {
        timer = nil
    }
}
