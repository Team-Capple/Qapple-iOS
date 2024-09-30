//
//  Date+Extension.swift
//  Capple
//
//  Created by 김민준 on 3/3/24.
//

import Foundation

extension Date {
    
    /// 전체 날짜 포맷 문자열을 반환합니다.
    /// ex) 03.03
    var MonthDayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: self)
    }
    
    /// 현재 날짜와 비교해 방금, n초전, n분 전, n시간 전, 하루 전, 날짜 출력 포맷을 반환합니다.
    var timeAgo: String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.second, .minute, .hour, .day],
            from: self, to: now
        )
        
        if let seconds = components.second,
           let minute = components.minute,
           let hour = components.hour,
           let day = components.day {
            
            if seconds < 10 && minute == 0 && hour == 0 && day == 0 {
                return "방금"
            } else if seconds < 60 && minute == 0 && hour == 0 && day == 0 {
                return "\(seconds)초 전"
            } else if minute < 60 && hour == 0 && day == 0 {
                return "\(minute)분 전"
            } else if hour < 24 && day == 0 {
                return "\(hour)시간 전"
            } else if day < 2 {
                return "하루 전"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM.dd"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                return dateFormatter.string(from: self)
            }
        } else {
            return "ERROR"
        }
    }
}
