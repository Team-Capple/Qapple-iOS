//
//  DayCounter+.swift
//  Qapple
//
//  Created by 김민준 on 3/4/25.
//

import Foundation

extension Date {
    
    /// 종료 날짜까지 얼마나 남았는지 반환합니다.
    var dayLeft: Int {
        let today = Calendar.utc.dateComponents([.year, .month, .day], from: .now)
        return Calendar.utc.dateComponents([.day], from: Calendar.utc.date(from: today)!, to: self).day!
    }
}
