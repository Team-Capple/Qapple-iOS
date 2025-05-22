//
//  AnswerListFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnswerListFeature {
    
    @ObservableState
    struct State: Equatable {
        var question: Question
        var answerList: [Answer] = []
        var totalCount: QappleAPI.TotalCount = 0
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var popularAnswerStatus: PopularAnswerCellStatus = .none
        var isLoading = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case refresh
        case pagination
        case answerListResponse([Answer], QappleAPI.TotalCount, QappleAPI.PaginationInfo)
        case paginagionResponse([Answer], QappleAPI.PaginationInfo)
        case filterBlockedUser
        case networkingFailed(Error)
        case seeMoreAction(Answer)
        case backButtonTapped
        case likeAnswerButtonTapped(Answer)
        case answerCommentButtonTapped(Answer)
        case fetchPopularAnswer(Answer)
        case likeAnswer(Answer)
        case toggleLoading(Bool)
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.answerRepository) var answerRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
            case .onAppear, .refresh:
                return .run { [question = state.question] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await answerRepository.fetchAnswerListOfQuestion(
                            question.id, nil
                        )
                        let currentHour = Calendar.current.component(.hour, from: .now)
                        
                        if question.isLived, !(currentHour > 12 && currentHour < 19){
                            if !(currentHour > 12 && currentHour < 19) {
                                let response = try await answerRepository.fetchPopularAnswer(question)
                                if let answer = response.0 {
                                    await send(.fetchPopularAnswer(answer))
                                }
                            }
                        } else {
                            let response = try await answerRepository.fetchPopularAnswer(question)
                            if let answer = response.0 {
                                await send(.fetchPopularAnswer(answer))
                            }
                        }
                        
                        await send(
                            .answerListResponse(
                                response.0,
                                response.1,
                                response.2
                            )
                        )
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .onDisappear:
                return .none
                
            case .pagination:
                return .run { [state = state]  send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await answerRepository.fetchAnswerListOfQuestion(
                            state.question.id,
                            Int(state.paginationInfo.threshold)
                        )
                        await send(.paginagionResponse(response.0, response.2))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .answerListResponse(answerList, totalCount, paginationInfo):
                state.answerList = answerList.reversed().filter(UserDefaults.filterAnswerBlockedUser)
                state.totalCount = totalCount
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginagionResponse(answerList, paginationInfo):
                let result = answerList.reversed().filter(UserDefaults.filterAnswerBlockedUser)
                state.answerList.insert(contentsOf: result, at: 0)
                state.paginationInfo = paginationInfo
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmBlockUser(sheetData)))))):
                guard case let .answer(answer) = sheetData else { return .none }
                return .run { send in
                    UserDefaults.addBlockedUser(answer.writerId)
                    await send(.sheet(.presented(.seeMore(.completionBlocking))))
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmBlockCompletion))))):
                state.sheet = nil
                return .send(.filterBlockedUser)
                
            case .filterBlockedUser:
                state.answerList = state.answerList.reversed().filter(UserDefaults.filterAnswerBlockedUser)
                return .none
                
            case let .likeAnswerButtonTapped(answer):
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await answerRepository.likeAnswer(answer.id)
                        GAService.log(.likeAnswerFromList(answer: answer))
                        await send(.likeAnswer(answer))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .answerCommentButtonTapped:
                return .none
                
            case let .fetchPopularAnswer(answer):
                state.popularAnswerStatus = .popularAnswer(answer, state.question)
                return .none
                
            case let .likeAnswer(answer):
                guard let currentAnswerIdx = state.answerList.firstIndex(where: { $0.id == answer.id })
                else { return .none }
                
                if state.answerList[currentAnswerIdx].isLiked {
                    state.answerList[currentAnswerIdx].heartCount -= 1
                } else {
                    state.answerList[currentAnswerIdx].heartCount += 1
                }
                state.answerList[currentAnswerIdx].isLiked.toggle()
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .seeMoreAction(answer):
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: answer.isMine ? .mine : .others,
                        dataType: .answer(answer)
                    )
                )
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
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .backButtonTapped, .sheet, .alert:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Sheet

extension AnswerListFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}
