//
//  CommentUseCase.swift
//  Qapple
//
//  Created by 문인범 on 8/22/24.
//

import SwiftUI

final class CommentViewModel: ObservableObject {

    @Published public var comments: [CommentResponse.Comment] = []
    
    // 호출 flag
    @Published public var isLoading: Bool = false
    
    // 댓글 불러오기
    @MainActor
    public func loadComments(boardId: Int, pageNumber: Int) async {
        self.isLoading = true
        
        do {
            let fetchResult = try await NetworkManager.fetchComments(boardId: boardId, pageNumber: pageNumber)
            let content = fetchResult.content
            
            self.comments = anonymizeComment(content)
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoading = false
    }
    
    // 댓글 좋아요 action
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
    
    // 댓글 달기 action
    @MainActor
    public func uploadComment(request: CommentRequest.UploadComment) async {
        self.isLoading = true
        
        do {
            _ = try await NetworkManager.postComment(requestBody: request)
        } catch {
            print(error.localizedDescription)
        }

        self.isLoading = false
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


extension CommentViewModel {
    // 이름을 익명화 해주는 method
    private func anonymizeComment(_ comments: [CommentResponse.Comment]) -> [CommentResponse.Comment] {
        // 아무개 번호
        var nameIndex = 0
        // 중복 여부 판단하는 딕셔너리
        var nameArray: [Int: String] = [:]
        
        let result = comments.map { comment in
            // 한번이라도 나온 writer인지 여부 판단
            let isContainName = nameArray.values.contains {
                $0 == comment.name
            }
            
            if !isContainName { // 처음 나오는 writer일 경우
                nameIndex += 1
                nameArray.updateValue(comment.name, forKey: nameIndex)
                
                
                return CommentResponse.Comment(
                    id: comment.id,
                    name: "러너 \(nameIndex)",
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt)
            } else { // 한번 이상 나온 writer일 경우
                // 해당 value의 key 값을 찾아 name의 index로 제공
                let currentIndex = nameArray
                    .filter { $0.value == comment.name }
                    .first!.key
                
                return CommentResponse.Comment(
                    id: comment.id,
                    name: "러너 \(currentIndex)",
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
