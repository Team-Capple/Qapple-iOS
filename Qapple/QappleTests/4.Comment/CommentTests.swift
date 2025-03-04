//
//  CommentTests.swift
//  QappleTests
//
//  Created by 문인범 on 2/28/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import Qapple



// MARK: - onAppear, refresh 관련
@MainActor
struct CommentTests {
    @Test("첫 화면 데이터 패치")
    func onAppear() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(\.commentListResponse) { state in
            state.commentList[0].anonymityId = -1
            state.commentList[1].anonymityId = 2
            state.commentList[2].anonymityId = 3
            state.commentList[3].anonymityId = 2
        }
        await store.receive(\.boardResponse) { state in
            state.board = sampleBoard
        }
        await store.receive(\.toggleLoading)
    }
    
    @Test("첫 화면 데이터 패치 에러")
    func onAppearWithError() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        } withDependencies: { feature in
            feature.commentRepository.fetchBoardCommentList = { _, _ in
                throw TestError.onAppearError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.onAppearError)
        }
    }
}


// MARK: - 페이지네이션 관련
extension CommentTests {
    @Test("페이지네이션")
    func pagination() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.pagination)
        
        await store.receive(\.paginationResponse) { state in
            state.paginationInfo = .init(threshold: "1234", hasNext: false)
        }
        await store.receive(\.toggleLoading)
    }
    
    @Test("페이지네이션 에러")
    func paginationWithError() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        } withDependencies: {
            $0.commentRepository.fetchBoardCommentList = { _, _ in
                throw TestError.paginationError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.pagination)
        
        await store.receive(\.toggleLoading)
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.paginationError)
        }
    }
}


// MARK: - 댓글 좋아요
extension CommentTests {
    @Test("댓글 좋아요", arguments: [
        BoardComment( // 좋아요 눌러진 댓글
            id: 1,
            writeId: 1,
            content: "테스트 댓글입니다.1",
            heartCount: 0,
            isLiked: false,
            isMine: true,
            isReport: false,
            createdAt: .now
        ),
        BoardComment( // 좋아요 눌러지지 않은 게시글
            id: 2,
            writeId: 1,
            content: "테스트 댓글입니다.2",
            heartCount: 1,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: .now
        )
    ])
    func likeCommentButtonTapped(comment: BoardComment) async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.commentListResponse([comment], .init(threshold: "1234", hasNext: false)))
        await store.send(.likeCommentButtonTapped(comment))
        
        await store.receive(\.toggleLoading)
        await store.receive(\.likeComment) { state in
            let likedComment = state.commentList.first!
            let count = comment.isLiked ? comment.heartCount - 1 : comment.heartCount + 1
            
            #expect(likedComment.isLiked != comment.isLiked)
            #expect(likedComment.heartCount == count)
        }
    }
    
    @Test("댓글 좋아요 에러")
    func likeCommentButtonTappedWithError() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        } withDependencies: {
            $0.commentRepository.likeBoardComment = { _ in
                throw TestError.likeError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(\.commentListResponse)
        let firstComment = store.state.commentList.first!
        
        await store.send(.likeCommentButtonTapped(firstComment))
        
        await store.receive(\.toggleLoading)
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.likeError)
        }
    }
}


// MARK: - 댓글 삭제
extension CommentTests {
    @Test("댓글 삭제")
    func deleteCommentButtonTapped() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(\.commentListResponse)
        let firstComment = store.state.commentList.first!
        
        await store.send(.deleteCommentButtonTapped(firstComment)) { state in
            state.alert = .confirmDeletion(firstComment.id)
        }
        await store.send(.alert(.presented(.confirmDeletion(firstComment.id))))
        
        await store.receive(\.toggleLoading)
        await store.receive(\.refresh)
        await store.receive(\.successDeletion) { state in
            state.alert = .successDeletion
        }
    }
    
    @Test("댓글 삭제 에러")
    func deleteCommentButtonTappedWithError() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        } withDependencies: {
            $0.commentRepository.deleteBoardComment = { _ in
                throw TestError.deleteError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        await store.receive(\.commentListResponse)
        let firstComment = store.state.commentList.first!
        
        await store.send(.deleteCommentButtonTapped(firstComment))
        await store.send(.alert(.presented(.confirmDeletion(firstComment.id))))
        
        await store.receive(\.toggleLoading)
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.deleteError)
        }
    }
}


// MARK: - 댓글 업로드
extension CommentTests {
    @Test("댓글 업로드")
    func uploadCommentButtonTapped() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.uploadCommentButtonTapped)
        
        await store.receive(\.toggleLoading)
        await store.receive(\.refresh)
    }
    
    @Test("댓글 업로드 에러")
    func uploadCommentButtonTappedWithError() async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        } withDependencies: {
            $0.commentRepository.postBoardComment = { _, _ in
                throw TestError.uploadError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.uploadCommentButtonTapped)
        
        await store.receive(\.toggleLoading)
        await store.receive(\.networkingFailed) { state in
            state.alert = .failedNetworking(with: TestError.uploadError)
        }
    }
}

// MARK: - 댓글 뷰에서 게시판 상호작용
extension CommentTests {
    @Test("게시판 상호작용 in 댓글", arguments: [
        BulletinBoard.init( // 본인의 게시글
            id: 1,
            writerId: 1,
            writerNickname: "테스트",
            content: "테스트입니다.",
            heartCount: 2,
            commentCount: 3,
            createAt: Date.distantPast,
            isMine: true,
            isReported: false,
            isLiked: false
        ),
        BulletinBoard.init( // 타인의 게시글
            id: 2,
            writerId: 2,
            writerNickname: "테스트",
            content: "테스트입니다.",
            heartCount: 2,
            commentCount: 3,
            createAt: Date.distantPast,
            isMine: false,
            isReported: false,
            isLiked: false
        )
    ])
    func deleteBoardInComment(board: BulletinBoard) async throws {
        let store = TestStore(initialState: .init(board: sampleBoard)) {
            CommentFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.send(.seeMoreAction) { state in
            state.sheet = .seeMore(
                .init(
                    sheetTarget: state.board.isMine ? .mine : .others,
                    dataType: .bulletinBoard(state.board)
                )
            )
        }
    }
}

extension CommentTests {
    private var sampleBoard: BulletinBoard {
        .init(
            id: 1,
            writerId: 1,
            writerNickname: "테스트",
            content: "테스트입니다.",
            heartCount: 2,
            commentCount: 3,
            createAt: Date.distantPast,
            isMine: true,
            isReported: false,
            isLiked: false
        )
    }

    private enum TestError: Error {
        case onAppearError
        case paginationError
        case likeError
        case deleteError
        case uploadError
    }
}
