//
//  Formatter+.swift
//  Capple
//
//  Created by 김민준 on 3/3/24.
//

import Foundation

// MARK: - Date

extension Date {
    
    /// DateFormatter 재사용을 위한 타입 프로퍼티
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        return formatter
    }()
    
    /// 날짜 변환 타입 열거형
    enum FormatType {
        case md
        case mdd
        case mmdd
        case mdKorean
    }
    
    /// 전체 날짜 포맷 문자열을 반환합니다.
    /// ex) 03.03
    func formatting(_ formatType: FormatType, separator: String = ".") -> String {
        switch formatType {
        case .md: Date.dateFormatter.dateFormat = "M\(separator)d"
        case .mdd: Date.dateFormatter.dateFormat = "M\(separator)dd"
        case .mmdd: Date.dateFormatter.dateFormat = "MM\(separator)dd"
        case .mdKorean: Date.dateFormatter.dateFormat = "M월 d일"
        }
        return Date.dateFormatter.string(from: self)
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
                return self.formatting(.mmdd)
            }
        } else {
            return "ERROR"
        }
    }
}

// MARK: - String

extension String {
    
    enum ISO8601ToDateFormat: String {
        case yearMonthDateTime = "yyyy-MM-dd'T'HH:mm:ss"
        case yearMonthDateTimeMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    }
    
    /// 서버에서 받은 시간(String)을 Date 타입으로 반환합니다.
    func ISO8601ToDate(_ format: ISO8601ToDateFormat) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        return .now
    }
    
    /// 서버에서 받은 태그(키워드)를 공백을 기준으로 분리해 컬렉션 타입으로 반환합니다.
    var splitTag: [String] {
        return self.split(separator: " ").map(String.init)
    }
}

// MARK: - TimeInterval

extension TimeInterval {
    
    /// 타이머 포맷으로 반환합니다.
    /// ex) 03:30:56
    var timerFormat: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self)!
    }
}
