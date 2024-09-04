//
//  CommentUseCase.swift
//  Qapple
//
//  Created by 문인범 on 8/22/24.
//

import SwiftUI

final class CommentUseCase: ObservableObject {
    @Published public var _state: State
    
    @Published public var comments: [ApiComment.Comment] = []
    
    @MainActor
    init() {
        self._state = State(
            post: Post(
                anonymityIndex: 1,
                isMine: false,
                content: "지금 누가 팀이 있고 없는지 궁금해요",
                isLike: true,
                likeCount: 32,
                commentCount: 32,
                writingDate: Date().addingTimeInterval(-10)
            ),
            comment: sampleComments
        )
    }
    
    func loadComments(boardId: Int) async {
        let urlString = ApiEndpoints.basicURLString(path: .comments)
        
        guard let url = URL(string: "\(urlString)/\(boardId)") else {
            print("잘못된 URL 입니다! in CommentView")
            return
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                return
            }
            
            let result = try JSONDecoder().decode(BaseResponse<ApiComment>.self, from: data)
            
            self.comments = result.result.boardCommentInfos
            print(self.comments)
        } catch {
            print(String(describing: error))
        }
        
    }
    
    private func postComment(boardId: Int, text: String) async {
        let urlString = ApiEndpoints.basicURLString(path: .createComment)
        
        guard let url = URL(string: "\(urlString)/\(boardId)") else {
            print("잘못된 URL 입니다! in CommentView")
            return
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let bodyText = text
            let body = try JSONEncoder().encode(bodyText)
            
            request.httpBody = body
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                return
            }
        } catch {
            print(String(describing: error))
        }
    }
}


extension CommentUseCase {
    struct State {
        let post: Post
        let comment: [Comment]
    }
}

extension CommentUseCase {
    enum Action {
        case upload(content: String, id: Int)
        case delete(id: Int)
        case report(id: Int)
        case like(id: Int)
    }
    
    func act(_ action: Action) async {
        switch action {
        case .upload(let content, let id):
            // TODO: 댓글 업로드 기능 구현
            print("댓글 업로드: \(content)")
            await postComment(boardId: id, text: content)
        case .delete(let id):
            // TODO: 댓글 삭제 기능 구현
            print("\(id)번째 댓글 삭제")
        case .report(let id):
            // TODO: 댓글 신고 기능 구현
            print("\(id)번째 댓글 신고")
        case .like(id: let id):
            // TODO: 댓글 좋아요 기능 구현
            print("\(id)번째 댓글 좋아요")
        }
    }
}


struct Comment: Identifiable {
    let id = UUID()
    let anonymityIndex: Int
    let isMine: Bool
    let isLike: Bool
    let likeCount: Int
    let content: String
    let timestamp: Date
}



struct ApiComment: Codable {
    
    let boardCommentInfos: [Comment]
    
    struct Comment: Codable, Identifiable {
        var id: Int
        var name: String
        var content: String
        var heartCount: Int
        var isLiked: Bool
        var createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case id = "boardCommentId"
            case name = "writer"
            case content
            case heartCount
            case isLiked
            case createdAt
        }
    }
    
    
}

private let sampleComments: [Comment] = [
    Comment(anonymityIndex: 1, isMine: false, isLike: false, likeCount: 10, content: "이말 완전 인정", timestamp: Date().addingTimeInterval(-60*60)),
    Comment(anonymityIndex: 1, isMine: false, isLike: false, likeCount: 4, content: "22", timestamp: Date().addingTimeInterval(-60*58)),
    Comment(anonymityIndex: 1, isMine: false, isLike: false, likeCount: 7, content: "나는 별로 안궁금한데?? 왜 이런거 궁금함? 난 이미 팀있지롱 ㅋ", timestamp: Date()),
    Comment(anonymityIndex: 1, isMine: false, isLike: true, likeCount: 23, content: "와 위 댓글 ㅁㅊ네", timestamp: Date().addingTimeInterval(-900)),
    Comment(anonymityIndex: 1, isMine: true, isLike: true, likeCount: 50, content: "왜 시비임? 현피ㄱ?", timestamp: Date().addingTimeInterval(-180)),
    Comment(anonymityIndex: 1, isMine: false, isLike: true, likeCount: 83, content: "뜨던지ㅋ 목요일 오후 10시 지곡회관으로 와라", timestamp: Date().addingTimeInterval(-53)),
    Comment(anonymityIndex: 1, isMine: true, isLike: true, likeCount: 125, content: "ㅋㅋ 한대 맞고 울지나 마라", timestamp: Date()),
]
