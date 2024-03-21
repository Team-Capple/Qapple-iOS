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
}
