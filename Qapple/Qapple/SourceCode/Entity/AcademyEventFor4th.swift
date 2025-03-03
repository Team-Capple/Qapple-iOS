//
//  AcademyEvent.swift
//  Qapple
//
//  Created by 김민준 on 11/27/24.
//

import Foundation

/// 아카데미 4기 이벤트 열거형
enum AcademyEventFor4th: CaseIterable {
    case newStart
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
    
    /// 현재 진행 중인 아카데미 이벤트를 반환합니다.
    static var currentEvent: AcademyEventFor4th? {
        let events = AcademyEventFor4th.allCases
        for event in events {
            let (startDate, endDate) = event.period
            if startDate...endDate ~= Date.now {
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
            if Date.now < startDate {
                return event
            }
        }
        return nil
    }
    
    /// 아카데미 이벤트 제목을 반환합니다.
    var title: String {
        switch self {
        case .newStart: "NEWSTART"
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
        case .newStart: (ymdToDate(1, 1), ymdToDate(3, 9))
        case .prelude: (ymdToDate(3, 10), ymdToDate(3, 15))
        case .challenge1: (ymdToDate(3, 17), ymdToDate(3, 29))
        case .bridge1: (ymdToDate(3, 31), ymdToDate(4, 5))
        case .challenge2: (ymdToDate(4, 7), ymdToDate(4, 26))
        case .bridge2: (ymdToDate(4, 28), ymdToDate(5, 3))
        case .challenge3: (ymdToDate(5, 5), ymdToDate(6, 14))
        case .bridge3: (ymdToDate(6, 16), ymdToDate(6, 21))
        case .challenge4: (ymdToDate(6, 21), ymdToDate(8, 2))
        case .bridge4: (ymdToDate(8, 4), ymdToDate(8, 9))
        case .challenge5: (ymdToDate(8, 11), ymdToDate(8, 23))
        case .bridge5: (ymdToDate(8, 25), ymdToDate(8, 29))
        case .challenge6: (ymdToDate(9, 1), ymdToDate(11, 29))
        case .epilogue: (ymdToDate(12, 1), ymdToDate(12, 13))
        }
    }
    
    /// 아카데미 이벤트 기간의 총 일수를 반환합니다.
    var totalDays: Int {
        let (startDate, endDate) = period
        return daysBetween(startDate, endDate)
    }
}

// MARK: - Helper

extension AcademyEventFor4th {
    
    /// 연, 월, 일을 인자로 받아 Date 타입을 반환합니다.
    private func ymdToDate(_ month: Int, _ day: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = 2025
        dateComponent.month = month
        dateComponent.day = day
        return Calendar.current.date(from: dateComponent)!
    }
    
    /// 두 날짜 사이의 일 수를 계산합니다.
    private func daysBetween(_ startDate: StartDate, _ endDate: EndDate) -> Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day! + 1
    }
}
