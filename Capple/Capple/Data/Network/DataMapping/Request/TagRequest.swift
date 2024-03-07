//
//  TagRequest.swift
//  Capple
//
//  Created by 김민준 on 3/7/24.
//

import Foundation

class TagRequest {
    
    /// 태그(키워드) 검색 구조체
    struct Search {
        let keyword: String // 검색할 태그(키워드)
    }
    
    /// 질문에 많이 사용된 태그(키워드) 조회 구조체
    struct PopularTagsInQuestion {
        let questionId: Int // 질문 아이디
    }
}
