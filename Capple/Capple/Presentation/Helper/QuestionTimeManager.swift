//
//  QuestionTimeManager.swift
//  Capple
//
//  Created by 김민준 on 2/22/24.
//

import Foundation

struct QuestionTimeManager {
    
    /// QuestionTimeZone을 현재 시간에 맞게 업데이트합니다.
    func fetchTimezone() -> QuestionTimeZone {
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents([.hour], from: date)
        guard let hour = components.hour else { fatalError("Calendar Components 에러") }
        
        var timeZone: QuestionTimeZone = .am
        
        if hour >= 1 && hour < 7 { timeZone = .amCreate }
        else if hour >= 7 && hour < 14 { timeZone = .am }
        else if hour >= 14 && hour < 18 { timeZone = .pmCreate }
        else if hour >= 18 || hour < 1 { timeZone = .pm }
        
        return timeZone
    }
    
    /// 다음 질문 생성까지 남은 시간을 문자열 형태로 반환합니다.
    /// ex) 03:35:56
    func fetchTimerSeconds(_ timeZone: QuestionTimeZone) -> String {
        let calendar = Calendar.current
        let date = Date()
        var targetTime = DateComponents()
        
        if timeZone == .amCreate { targetTime = DateComponents(hour: 1) }
        else if timeZone == .pmCreate { targetTime = DateComponents(hour: 18) }
        
        guard let targetDate = calendar.nextDate(after: date, matching: targetTime, matchingPolicy: .strict) else { return "00:00:00" }
        return targetDate.timeIntervalSince(date).timerFormat
    }
}
