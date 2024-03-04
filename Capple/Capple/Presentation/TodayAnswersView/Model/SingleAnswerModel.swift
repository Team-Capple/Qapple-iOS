//
//  TodayAnswerModel.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
struct SingleAnswer: Identifiable {
    var id: Int
    var name: String
    var content: String
    var tags: [String]
    var likes: Int
    // 여기에 더 많은 필드를 추가할 수 있습니다.
}

