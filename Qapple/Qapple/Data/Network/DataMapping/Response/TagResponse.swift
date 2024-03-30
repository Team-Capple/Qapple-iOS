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
    
    /// 질문에 많이 사용된 태그(키워드) 조회 Response
    struct PopularTagsInQuestion: Codable {
        let tags: [String]
    }
}
