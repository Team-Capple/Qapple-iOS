//
//  MyAnswerListFeature.swift
//  Qapple
//
//  Created by Simmons on 2/2/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyAnswerListFeature {
    
    @ObservableState
    struct State: Equatable {
        var myAnswerList: [Answer] = []
        var totalCount: QappleAPI.TotalCount = 0
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var isLoading = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case refresh
        case pagination
        case answerListResponse(
            [Answer],
            QappleAPI.PaginationInfo
        )
        case paginagionResponse(
            [Answer],
            QappleAPI.PaginationInfo
        )
        case seeMoreAction(Answer)
        case backButtonTapped
        case networkingFailed(Error)
        case toggleLoading(Bool)
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.answerRepository) var answerRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await answerRepository.fetchAnswerListOfProfile(nil)
                        await send(.answerListResponse(response.0, response.1))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .pagination:
                return .run { [state = state]  send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    let response = try await answerRepository.fetchAnswerListOfProfile(
                        Int(state.paginationInfo.threshold)
                    )
                    await send(.paginagionResponse(response.0, response.1))
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .answerListResponse(answerList, paginationInfo):
                state.myAnswerList = answerList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginagionResponse(answerList, paginationInfo):
                state.myAnswerList.insert(contentsOf: answerList, at: 0)
                state.paginationInfo = paginationInfo
                return .none
                
            case let .seeMoreAction(answer):
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: .mine,
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
                    await send(.refresh)
                }
                
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .alert, .sheet:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$sheet, action: \.sheet)
    }
}

// MARK: - Sheet

extension MyAnswerListFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}
