//
//  String+Extension.swift
//  Capple
//
//  Created by 김민준 on 3/18/24.
//

import Foundation

extension String {
    
    /// 서버에서 받은 태그(키워드)를 공백을 기준으로 분리해 컬렉션 타입으로 반환합니다.
    var splitTag: [String] {
        return self.split(separator: " ").map(String.init)
    }
    
    /// 서버에서 받은 시간(String)을 Date 타입으로 반환합니다.
    var ISO8601ToDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        return .now
    }
}
