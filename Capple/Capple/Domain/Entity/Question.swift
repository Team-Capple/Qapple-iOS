import Foundation

struct Question: Identifiable, Codable {
    var id: Int
    var title: String
    var detail: String
    var tags: [String]
    var likes: Int
    var comments: Int
}

