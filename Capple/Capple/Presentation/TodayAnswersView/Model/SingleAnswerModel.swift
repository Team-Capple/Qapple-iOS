//
//  TodayAnswerModel.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation

struct ServerResponse: Codable {
    let timeStamp: String
    let code: String
    let message: String
    let result: AnswerResult
}

struct AnswerResult: Codable {
    var answerInfos: [Answer]
}

struct Answer: Codable {
    var profileImage: String?
    var nickname: String?
    var content: String?
    var tags: String?
    
}
