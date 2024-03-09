//
//  PathModel.swift
//  Capple
//
//  Created by 김민준 on 3/9/24.
//

import Foundation

enum PathType: Hashable {
    case answer // 답변하기
    case confirmAnswer // 답변확인(키워드선택)
    case searchKeyword // 키워드 검색
}

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
