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
    let result: [Questions]
}

struct Questions: Codable {
    var questionId: Int?
    var questionStatus: String?
    var content: String?
    var timeZone: String?
    var date: Date?
    var state: String?
    var keywords: [String]?
    var likes: Int?
    var comments: Int?
}

