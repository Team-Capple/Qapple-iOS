//
//  AcademyEvent.swift
//  Qapple
//
//  Created by 김민준 on 11/27/24.
//

import Foundation

/// 아카데미 4기 이벤트 열거형
enum AcademyEventFor4th: CaseIterable {
    case fourthStart
    case prelude
    case challenge1
    case bridge1
    case challenge2
    case bridge2
    case challenge3
    case bridge3
    case challenge4
    case bridge4
    case challenge5
    case bridge5
    case challenge6
    case epilogue
    
    typealias StartDate = Date
    typealias EndDate = Date
    
    /// 재사용을 위한 DateComponents
    private static var dateComponent = DateComponents()
    
    /// 현재 진행 중인 아카데미 이벤트를 반환합니다.
    static var currentEvent: AcademyEventFor4th? {
        let events = AcademyEventFor4th.allCases
        for event in events {
            let (startDate, endDate) = event.period
            if startDate...endDate ~= today {
                return event
            }
        }
        return nil
    }
    
    /// 다음에 다가올 아카데미 이벤트를 반환합니다.
    static var nextEvent: AcademyEventFor4th? {
        let events = AcademyEventFor4th.allCases
        for event in events {
            let (startDate, _) = event.period
            if today < startDate {
                return event
            }
        }
        return nil
    }
    
    /// 아카데미 이벤트 제목을 반환합니다.
    var title: String {
        switch self {
        case .fourthStart: "4th START"
        case .prelude: "PRELUDE"
        case .challenge1: "CHALLENGE 1"
        case .bridge1: "BRIDGE 1"
        case .challenge2: "CHALLENGE 2"
        case .bridge2: "BRIDGE 2"
        case .challenge3: "CHALLENGE 3"
        case .bridge3: "BRIDGE 3"
        case .challenge4: "CHALLENGE 4"
        case .bridge4: "BRIDGE 4"
        case .challenge5: "CHALLENGE 5"
        case .bridge5: "BRIDGE 5"
        case .challenge6: "CHALLENGE 6"
        case .epilogue: "EPILOGUE"
        }
    }
    
    /// 아카데미 이벤트 기간을 시작날짜, 종료날짜 형태의 튜플로 반환합니다.
    var period: (StartDate, EndDate) {
        switch self {
        case .fourthStart: (ymdToDate(1, 1), ymdToDate(3, 9))
        case .prelude: (ymdToDate(3, 10), ymdToDate(3, 16))
        case .challenge1: (ymdToDate(3, 17), ymdToDate(3, 30))
        case .bridge1: (ymdToDate(3, 31), ymdToDate(4, 6))
        case .challenge2: (ymdToDate(4, 7), ymdToDate(4, 27))
        case .bridge2: (ymdToDate(4, 28), ymdToDate(5, 7))
        case .challenge3: (ymdToDate(5, 8), ymdToDate(6, 15))
        case .bridge3: (ymdToDate(6, 16), ymdToDate(6, 20))
        case .challenge4: (ymdToDate(6, 23), ymdToDate(8, 3))
        case .bridge4: (ymdToDate(8, 4), ymdToDate(8, 10))
        case .challenge5: (ymdToDate(8, 11), ymdToDate(8, 24))
        case .bridge5: (ymdToDate(8, 25), ymdToDate(8, 31))
        case .challenge6: (ymdToDate(9, 1), ymdToDate(11, 30))
        case .epilogue: (ymdToDate(12, 1), ymdToDate(12, 12))
        }
    }
    
    /// 아카데미 이벤트 기간의 총 일수를 반환합니다.
    var totalDays: Int {
        let (startDate, endDate) = period
        return daysBetween(startDate, endDate) + 1
    }
}

// MARK: - Helper

extension AcademyEventFor4th {
    
    /// 오늘 날짜를 UTC 형식으로 반환합니다.
    private static var today: Date {
        let todayComponent = Calendar.utc.dateComponents([.year, .month, .day], from: .now)
        return Calendar.utc.date(from: todayComponent)!
    }
    
    /// 연, 월, 일을 인자로 받아 Date 타입을 반환합니다.
    private func ymdToDate(_ month: Int, _ day: Int) -> Date {
        AcademyEventFor4th.dateComponent.year = 2025
        AcademyEventFor4th.dateComponent.month = month
        AcademyEventFor4th.dateComponent.day = day
        return Calendar.utc.date(from: AcademyEventFor4th.dateComponent)!
    }
    
    /// 두 날짜 사이의 일 수를 계산합니다.
    private func daysBetween(_ startDate: StartDate, _ endDate: EndDate) -> Int {
        Calendar.utc.dateComponents([.day], from: startDate, to: endDate).day!
    }
}
