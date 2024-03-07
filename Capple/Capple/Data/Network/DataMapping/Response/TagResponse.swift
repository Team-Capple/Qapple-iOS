//
//  TagResponse.swift
//  Capple
//
//  Created by 김민준 on 3/7/24.
//

import Foundation

struct TagResponse {
    
    /// 태그(키워드) 검색 Response
    struct Search: Codable {
        let tags: [String]
    }
}
