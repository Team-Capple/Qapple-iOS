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
}
