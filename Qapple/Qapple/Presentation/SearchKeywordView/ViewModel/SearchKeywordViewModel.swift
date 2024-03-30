//
//  SearchKeywordViewModel.swift
//  Capple
//
//  Created by 김민준 on 2/26/24.
//

import Foundation

final class SearchKeywordViewModel: ObservableObject {
    
    @Published var search: String
    @Published var keywordPreviews: [Keyword]
    
    init(search: String = "") {
        self.search = search
        self.keywordPreviews = [
            .init(name: "와플유니버시티"),
            .init(name: "당근맨"),
            .init(name: "무자비"),
            .init(name: "잔망루피"),
            .init(name: "애플"),
            .init(name: "아카데미"),
            .init(name: "디벨로퍼"),
            .init(name: "디자이너")
        ]
    }
}
