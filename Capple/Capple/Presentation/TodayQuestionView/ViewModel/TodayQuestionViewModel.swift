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
    
    // TODO: - 임시 답변 리스트
    var answerList = [1, 2, 3]
    
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
    var listTitleText: String {
        
        // Q. Mark
        var questionMark = AttributedString("Q.")
        questionMark.foregroundColor = BrandPink.text
        
        // TODO: - 서버 통신으로 질문 가져오기
        var text = "리스트 타이틀"
        if state == .creating { text = "\(questionMark) 아카데미 러너 중\n가장 마음에 드는 유형이 있나요?" }
        else if state == .ready { text = "어떤 질문이 나왔을까요?" }
        else if state == .complete { text = "\(questionMark) 최근에 먹었던 음식 중\n가장 인상깊었던 것은 무엇인가요?" }
        return text
    }
    
    /// 리스트 서브 타이틀 텍스트를 반환합니다.
    var listSubText: String {
        var text = "리스트 서브 타이틀"
        if state == .creating { text = "이전 답변 좋아요 TOP 3" }
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
