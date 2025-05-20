//
//  AnswerCommentFeature.swift
//  Qapple
//
//  Created by 문인범 on 4/14/25.
//

import Foundation
import ComposableArchitecture


@Reducer
struct AnswerCommentFeature {
    @ObservableState
    struct State: Equatable {
        var answer: Answer
        var commentText: String = ""
        var commentList: [AnswerComment] = []
        var isLoading: Bool = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case onAppear
        case onDisappear
        case refresh
        case commentListResponse([AnswerComment])
        
        case backButtonTapped
        case likeCommentButtonTapped(AnswerComment)
        case likeComment(Int)
        case uploadCommentButtonTapped
        case commentTextReset
        case reportButtonTapped(AnswerComment)
        case deleteCommentButtonTapped(AnswerComment)
        case successDeletion
        
        case likeAnswerButtonTapped
        case likeAnswer
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
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.answerRepository) var answerRepository
    @Dependency(\.answerCommentRepository) var answerCommentRepository
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { [answerId = state.answer.id] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let commentResponse = try await answerCommentRepository.fetchAnswerComments(answerId)
                        // TODO: 5/20 단일 답변 패치 필요?
                        await send(.commentListResponse(commentResponse))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .onDisappear:
                return .none
                
            case let .commentListResponse(commentList):
                state.commentList = anonymizeCommentList(state.answer.writerId, commentList)
                return .none
                
            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }
                
            case let .likeCommentButtonTapped(answerComment):
                HapticService.impact(style: .light)
                return .run { [answer = state.answer] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerCommentRepository.likeAnswerComment(answerComment.id)
                        await send(.likeComment(answerComment.id))
                        GAService.log(.likeAnswerComment(answer: answer, answerComment: answerComment))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .likeComment(answerCommentId):
                if let index = state.commentList.firstIndex(where: { $0.id == answerCommentId }) {
                    state.commentList[index].isLiked.toggle()
                    state.commentList[index].heartCount += state.commentList[index].isLiked ? 1 : -1
                }
                return .none
                
            case .uploadCommentButtonTapped:
                return .run { [
                    text = state.commentText,
                    answer = state.answer
                ] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerCommentRepository.createAnswerComment(answer.id, text)
                        HapticService.notification(type: .success)
                        GAService.log(.postAnswerComment(answer: answer, comment: text))
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
                
            case let .deleteCommentButtonTapped(answerComment):
                HapticService.notification(type: .error)
                state.alert = .confirmDeletion(answerComment.id)
                return .none
                
            case .successDeletion:
                state.alert = .successDeletion
                NotificationCenter.default.post(name: .updateCommentCellToggle, object: nil)
                return .send(.refresh)
                
            case .likeAnswerButtonTapped:
                HapticService.impact(style: .light)
                return .run { [answer = state.answer] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerRepository.likeAnswer(answer.id)
                        await send(.likeAnswer)
                        if !answer.isLiked { GAService.log(.likeAnswerFromDetail(answer: answer)) }
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .likeAnswer:
                if state.answer.isLiked {
                    state.answer.heartCount -= 1
                } else {
                    state.answer.heartCount += 1
                }
                state.answer.isLiked.toggle()
                return .none
                
            case .seeMoreAction:
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: state.answer.isMine ? .mine : .others,
                        dataType: .answer(state.answer)
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
                guard case let .answer(answer) = sheetData else { return .none }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerRepository.deleteAnswer(answer.id)
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
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmBlockUser(sheetData)))))):
                guard case let .answer(answer) = sheetData else { return .none }
                return .run { send in
                    UserDefaults.addBlockedUser(answer.writerId)
                    await send(.sheet(.presented(.seeMore(.completionBlocking))))
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmBlockCompletion))))):
                state.sheet = nil
                return .send(.onDisappear)
                
            case let .alert(.presented(.confirmDeletion(answerCommentId))):
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerCommentRepository.deleteAnswerComment(answerCommentId)
                        await send(.refresh)
                        await send(.successDeletion)
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

extension AnswerCommentFeature {
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}

// MARK: - CommentAlert

extension AlertState where Action == AnswerCommentFeature.Action.Alert {
    static func confirmDeletion(_ answerCommentId: Int) -> Self {
        return Self {
            TextState("정말로 댓글을 삭제하시겠습니까?")
        } actions: {
            ButtonState(role: .cancel){
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmDeletion(answerCommentId)) {
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

extension AnswerCommentFeature {
    // 이름을 익명화 해주는 method
    private func anonymizeCommentList(_ answerWriterId: Int, _ commentList: [AnswerComment]) -> [AnswerComment] {
        var anonymousArray: [Int: Int] = [:]
        var anonymousIndex: Int = 0
        
        return commentList.map { comment in
            let isContainName = anonymousArray.values.contains { $0 == comment.writeId }
            
            if !isContainName {
                anonymousIndex += 1
                
                let anonymityId = (comment.writeId == answerWriterId) ? -1 : anonymousIndex
                
                anonymousArray.updateValue(comment.writeId, forKey: anonymityId)
                
                return AnswerComment(
                    id: comment.id,
                    writeId: comment.writeId,
                    writerGeneration: "3기",
                    content: comment.content,
                    heartCount: comment.heartCount,
                    isLiked: comment.isLiked,
                    isMine: comment.isMine,
                    isReport: comment.isReport,
                    createdAt: comment.createdAt,
                    anonymityId: (comment.writeId == answerWriterId) ? -1 : anonymousIndex
                )
            } else {
                let currentIndex = anonymousArray.first(where: { $0.value == comment.writeId })?.key ?? 0
                
                return AnswerComment(
                    id: comment.id,
                    writeId: currentIndex,
                    writerGeneration: "3기",
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


extension AnswerCommentFeature {
    public static var sampleComment: [AnswerComment] {
        var result = [AnswerComment]()
        for i in 0..<10 {
            result.append(.init(
                id: i,
                writeId: i,
                writerGeneration: "4기",
                content: "\(i)번째 댓글",
                heartCount: i,
                isLiked: false,
                isMine: false,
                isReport: false,
                createdAt: .init(),
                anonymityId: i
            ))
        }
        
        result.append(.init(
            id: 10,
            writeId: 10,
            writerGeneration: "3기",
            content: "하이용",
            heartCount: 3,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: .init(),
            anonymityId: -1
        ))
        return result
    }
}
