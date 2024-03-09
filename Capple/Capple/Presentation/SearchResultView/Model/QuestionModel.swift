//
//  QuestionModel.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/7/24.
//

import Foundation


struct QuestionsResponse: Codable,Identifiable {
    var id: Int?
    let timeStamp: String
    let code: String
    let message: String
    let result: [QuestionsInfos]
}
struct QuestionsInfos: Codable, Identifiable {
    var id: Int?
    var questionId: Int?
    var questionStatus: String?
    var content: String?
    var timeZone: String?
    var date: Date?
    var state: String?
    var tag: String?
    var likeCount: Int?
    var commentCount: Int?
}
