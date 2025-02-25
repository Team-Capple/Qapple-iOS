//
//  CommentFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CommentFeature {
    @ObservableState
    struct State: Equatable {
        var board: BulletinBoard
        var commentText: String = ""
        var commentList: [BoardComment] = []
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var isLoading: Bool = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case onAppear
        case onDisappear
        case refresh
        case pagination
        case commentListResponse([BoardComment], QappleAPI.PaginationInfo)
        case paginationResponse([BoardComment], QappleAPI.PaginationInfo)
        case boardResponse(BulletinBoard)
        
        case backButtonTapped
        case likeCommentButtonTapped(BoardComment)
        case likeComment(Int)
        case uploadCommentButtonTapped
        case commentTextReset
        case reportButtonTapped(BoardComment)
        case deleteCommentButtonTapped(BoardComment)
        case successDeletion
        
        case likeBoardButtonTapped
        case likeBoard
        case seeMoreAction
        case networkingFailed(Error)
        case toggleLoading(Bool)
        case binding(BindingAction<State>)
        
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmDeletion(Int)
            case successDeletion
        }
    }
    
    @Dependency(\.commentRepository) var commentRepository
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { [boardId = state.board.id] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let commentResponse = try await commentRepository.fetchBoardCommentList(boardId, nil)
                        let boardResponse = try await bulletinBoardRepository.fetchSingleBoard(boardId)
                        await send(.commentListResponse(commentResponse.0, commentResponse.1))
                        await send(.boardResponse(boardResponse))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .onDisappear:
                return .none
                
            case .pagination:
                return .run { [
                    boardId = state.board.id,
                    threshold = Int(state.paginationInfo.threshold)
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await commentRepository.fetchBoardCommentList(boardId, threshold)
                        await send(.paginationResponse(response.0, response.1))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .commentListResponse(commentList, paginationInfo):
                state.commentList = anonymizeCommentList(state.board.writerId, commentList)
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginationResponse(commentList, paginationInfo):
                state.commentList.append(contentsOf: anonymizeCommentList(state.board.writerId, commentList))
                state.paginationInfo = paginationInfo
                return .none
                
            case let .boardResponse(board):
                state.board = board
                return .none
                
            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case let .likeCommentButtonTapped(boardComment):
                HapticService.impact(style: .light)
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await commentRepository.likeBoardComment(boardComment.id)
                        await send(.likeComment(boardComment.id))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .likeComment(boardCommentId):
                if let index = state.commentList.firstIndex(where: { $0.id == boardCommentId }) {
                    state.commentList[index].isLiked.toggle()
                    state.commentList[index].heartCount += state.commentList[index].isLiked ? 1 : -1
                }
                return .none
                
            case .uploadCommentButtonTapped:
                HapticService.notification(type: .success)
                return .run { [
                    text = state.commentText,
                    boardId = state.board.id
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await commentRepository.postBoardComment(boardId, text)
                        await send(.refresh)
                        await send(.commentTextReset)
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .commentTextReset:
                state.commentText = ""
                return .none
                
            case .reportButtonTapped:
                NotificationCenter.default.post(name: .updateCommentCellToggle, object: nil)
                return .none
                
            case let .deleteCommentButtonTapped(boardComment):
                HapticService.notification(type: .error)
                state.alert = .confirmDeletion(boardComment.id)
                return .none
                
            case .successDeletion:
                state.alert = .successDeletion
                NotificationCenter.default.post(name: .updateCommentCellToggle, object: nil)
                return .send(.refresh)
                
            case .likeBoardButtonTapped:
                HapticService.impact(style: .light)
                return .run { [board = state.board] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.likeBoard(board.id)
                        await send(.likeBoard)
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .likeBoard:
                if state.board.isLiked {
                    state.board.heartCount -= 1
                } else {
                    state.board.heartCount += 1
                }
                state.board.isLiked.toggle()
                return .none
                
            case .seeMoreAction:
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: state.board.isMine ? .mine : .others,
                        dataType: .bulletinBoard(state.board)
                    )
                )
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.commentText):
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmDeletion(sheetData)))))):
                guard case let .bulletinBoard(board) = sheetData else { return .none }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.deleteBoard(board.id)
                        await send(.sheet(.presented(.seeMore(.completionDeletion))))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmCompletion))))):
                state.sheet = nil
                return .run { send in
                    await send(.onDisappear)
                }
                
            case .sheet(.presented(.seeMore(.reportButtonTapped))):
                state.sheet = nil
                return .none
                
            case let .alert(.presented(.confirmDeletion(boardCommentId))):
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await commentRepository.deleteBoardComment(boardCommentId)
                        await send(.refresh)
                        await send(.successDeletion)
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .binding, .sheet, .alert:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardSheet

extension CommentFeature {
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}

// MARK: - CommentAlert

extension AlertState where Action == CommentFeature.Action.Alert {
    static func confirmDeletion(_ boardCommentId: Int) -> Self {
        return Self {
            TextState("정말로 댓글을 삭제하시겠습니까?")
        } actions: {
            ButtonState(role: .cancel){
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmDeletion(boardCommentId)) {
                TextState("삭제")
            }
        }
    }
    
    static let successDeletion = Self {
        TextState("댓글이 삭제되었습니다")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    }
}

extension CommentFeature {
    // 이름을 익명화 해주는 method
    private func anonymizeCommentList(_ BoardWriterId: Int, _ commentList: [BoardComment]) -> [BoardComment] {
        var anonymousArray: [Int: Int] = [:]
        var anonymousIndex: Int = 0
        
        return commentList.map { comment in
            let isContainName = anonymousArray.values.contains { $0 == comment.writeId }
            
            if !isContainName {
                anonymousIndex += 1
                
                let anonymityId = (comment.writeId == BoardWriterId) ? -1 : anonymousIndex
                
                anonymousArray.updateValue(comment.writeId, forKey: anonymityId)
                
                return BoardComment(
                    id: comment.id,
                    writeId: comment.writeId,
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt,
                    anonymityId: (comment.writeId == BoardWriterId) ? -1 : anonymousIndex
                )
            } else {
                let currentIndex = anonymousArray.first(where: { $0.value == comment.writeId })?.key ?? 0
                
                return BoardComment(
                    id: comment.id,
                    writeId: currentIndex,
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt,
                    anonymityId: currentIndex
                )
            }
        }
    }
}
