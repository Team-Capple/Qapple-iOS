//
//  Date+Extension.swift
//  Capple
//
//  Created by 김민준 on 3/3/24.
//

import Foundation

extension Date {
    
    /// 전체 날짜 포맷 문자열을 반환합니다.
    /// ex) 2024.03.03
    var fullDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
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
        
        if let seconds = components.second, seconds < 10 {
            return "방금"
        }
        
        if let seconds = components.second, seconds < 60 {
            return "\(seconds)초 전"
        }
        
        if let minutes = components.minute, minutes < 5 {
            return "\(minutes)분 전"
        }
        
        if let minutes = components.minute, minutes < 60 {
            return "\(minutes)분 전"
        }
        
        if let hours = components.hour, hours < 24 {
            return "\(hours)시간 전"
        }
        
        if let days = components.day, days < 1 {
            return "하루 전"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
