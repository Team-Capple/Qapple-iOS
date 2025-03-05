//
//  Calendar+.swift
//  Qapple
//
//  Created by 김민준 on 3/4/25.
//

import Foundation

extension Calendar {
    
    /// 재사용을 위한 UTC 기반 캘린더
    static let utc: Self = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}
