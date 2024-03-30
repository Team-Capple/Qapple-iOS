//
//  TimeInterval+Extension.swift
//  Capple
//
//  Created by 김민준 on 2/22/24.
//

import Foundation

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
