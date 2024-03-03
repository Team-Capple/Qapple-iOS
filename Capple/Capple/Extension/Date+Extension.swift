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
}
