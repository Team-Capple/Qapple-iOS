//
//  CommentUseCase.swift
//  Qapple
//
//  Created by 문인범 on 8/22/24.
//

import SwiftUI

final class CommentViewModel: ObservableObject {

    @Published public var comments: [CommentResponse.Comments.Comment] = []
    
    // 댓글 불러오기
    @MainActor
    public func loadComments(boardId: Int) async {
        do {
            let result = try await NetworkManager.fetchComments(boardId: boardId)
            self.comments = result.boardCommentInfos
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 댓글 좋아요 action
    @MainActor
    public func likeComment(commentId: Int) async {
        do {
            _ = try await NetworkManager.likeComment(commentId: commentId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 댓글 달기 action
    @MainActor
    public func uploadComment(request: CommentRequest.UploadComment) async {
        do {
            _ = try await NetworkManager.postComment(requestBody: request)
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension CommentViewModel {
    enum Action {
        case upload(request: CommentRequest.UploadComment)
        case delete(id: Int)
        case report(id: Int)
        case like(id: Int)
    }
    
    func act(_ action: Action) async {
        switch action {
        case .upload(let request):
            // TODO: 댓글 업로드 기능 구현
            print("댓글 업로드: \(request.content)")
            await uploadComment(request: request)
        case .delete(let id):
            // TODO: 댓글 삭제 기능 구현
            print("\(id)번째 댓글 삭제")
        case .report(let id):
            // TODO: 댓글 신고 기능 구현
            print("\(id)번째 댓글 신고")
        case .like(id: let id):
            // TODO: 댓글 좋아요 기능 구현
            print("\(id)번째 댓글 좋아요")
            await likeComment(commentId: id)
            
        }
    }
}
