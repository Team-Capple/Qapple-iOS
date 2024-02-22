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
    
    init() {
        let currentTimeZone = dateManager.fetchTimezone()
        self.timeZone = currentTimeZone
        self.state = .creating
        self.timerSeconds = dateManager.fetchTimerSeconds(currentTimeZone)
    }
}

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
        var text = "질문 타이틀"
        if state == .creating { text = "이전 질문 보러가기" }
        else if state == .ready { text = "질문에 답변하기" }
        else if state == .complete { text = "다른 답변 둘러보기" }
        return text
    }
    
    /// 현재 시간에 맞춰 질문 시간을 업데이트합니다.
    func updateTimeZone() {
        timeZone = dateManager.fetchTimezone()
    }
    
    /// 타이머를 실행합니다.
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timerSeconds = self.dateManager.fetchTimerSeconds(self.timeZone)
        }
    }
    
    /// 타이머를 초기화합니다.
    func stopTimer() {
        timer = nil
    }
}
