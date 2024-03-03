import Foundation

struct Question: Identifiable, Codable {
    var id: Int
    var timeZone: QuestionTimeZone
    var date: Date
    var state: QuestionState
    var title: String
    var keywords: [Keyword]
    var likes: Int
    var comments: Int
}

