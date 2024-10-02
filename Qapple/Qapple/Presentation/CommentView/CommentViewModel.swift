//
//  CommentUseCase.swift
//  Qapple
//
//  Created by 문인범 on 8/22/24.
//

import SwiftUI

final class CommentViewModel: ObservableObject {

    @Published public var comments: [CommentResponse.Comment] = []
    @Published public var isLoading: Bool = false
    @Published var pageNumber: Int = 0
    @Published var threshold: Int?
    @Published var hasPrevious: Bool = false
    @Published var hasNext: Bool = false
    
    public var postId: Int?
    
    private var anonymousArray: [Int: Int] = [:]
    private var anonymousIndex: Int = 0
    
    @MainActor
    public func loadComments(boardId: Int) async {
        self.isLoading = true
        
        do {
            let fetchResult = try await NetworkManager.fetchComments(
                boardId: boardId,
                threshold: threshold,
                pageNumber: pageNumber,
                pageSize: 25
            )
            let content = fetchResult.content
            self.comments += anonymizeComment(content)
            self.pageNumber += 1
            self.threshold = Int(fetchResult.threshold)
            self.hasPrevious = fetchResult.hasPrevious
            self.hasNext = fetchResult.hasNext
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoading = false
    }
    
    // 댓글 리프레쉬
    @MainActor
    public func refreshComments(boardId: Int) async {
        self.isLoading = true
        self.pageNumber = 0
        self.hasPrevious = false
        self.hasNext = false
        self.threshold = nil
        
        do {
            let fetchResult = try await NetworkManager.fetchComments(
                boardId: boardId,
                threshold: threshold,
                pageNumber: pageNumber,
                pageSize: 25
            )
            print(fetchResult.hasNext)
            let content = fetchResult.content
            self.comments.removeAll()
            self.comments += anonymizeComment(content)
            self.pageNumber += 1
            self.threshold = Int(fetchResult.threshold)
            self.hasPrevious = fetchResult.hasPrevious
            self.hasNext = fetchResult.hasNext
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoading = false
    }
    
    /// 댓글 좋아요 action
    @MainActor
    public func likeComment(commentId: Int) async {
        self.isLoading = true
        
        do {
            _ = try await NetworkManager.likeComment(commentId: commentId)
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoading = false
    }
    
    /// 댓글 달기 action
    @MainActor
    public func uploadComment(id: Int, request: CommentRequest.UploadComment) async {
        self.isLoading = true
        
        do {
            _ = try await NetworkManager.postComment(id: id, requestBody: request)
        } catch {
            print(error.localizedDescription)
        }

        self.isLoading = false
    }
    
    /// 댓글 삭제
    @MainActor
    public func deleteComment(id: Int) async {
        self.isLoading = true
        
        do {
            _ = try await NetworkManager.deleteComment(commentId: id)
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoading = false
    }
}


extension CommentViewModel {
    enum Action {
        case upload(id: Int, request: CommentRequest.UploadComment)
        case delete(id: Int)
        case report(id: Int)
        case like(id: Int)
    }
    
    func act(_ action: Action) async {
        switch action {
        case .upload(let id, let request):
            print("댓글 업로드: \(request.comment)")
            await uploadComment(id: id, request: request)
        case .delete(let id):
            print("\(id)번째 댓글 삭제")
            await deleteComment(id: id)
        case .report(let id):
            print("\(id)번째 댓글 신고")
        case .like(id: let id):
            print("\(id)번째 댓글 좋아요")
            await likeComment(commentId: id)
        }
    }
}

extension CommentViewModel {
    
    // 이름을 익명화 해주는 method
    private func anonymizeComment(_ comments: [CommentResponse.Comment]) -> [CommentResponse.Comment] {
        guard let postWriterId = self.postId else {
            return []
        }
        
        let result = comments.map { comment in
            
            // 한번이라도 나온 writer인지 여부 판단
            let isContainName = self.anonymousArray.values.contains {
                $0 == comment.writerId
            }
            
            if !isContainName { // 처음 나오는 writer일 경우
                self.anonymousIndex += 1
                
                if comment.writerId == postWriterId {
                    self.anonymousArray.updateValue(comment.writerId, forKey: -1)
                } else {
                    self.anonymousArray.updateValue(comment.writerId, forKey: self.anonymousIndex)
                }
                
                return CommentResponse.Comment(
                    id: comment.id,
                    writerId: (comment.writerId == postWriterId) ? -1 : self.anonymousIndex,
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt)
            } else { // 한번 이상 나온 writer일 경우
                // 해당 value의 key 값을 찾아 name의 index로 제공
                let currentIndex = self.anonymousArray
                    .filter { $0.value == comment.writerId }
                    .first!.key
                
                return CommentResponse.Comment(
                    id: comment.id,
                    writerId: currentIndex,
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt)
            }
        }
        
        return result
    }
}
