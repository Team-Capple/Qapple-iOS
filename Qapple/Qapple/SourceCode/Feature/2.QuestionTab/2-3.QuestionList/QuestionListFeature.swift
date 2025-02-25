//
//  QuestionListFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/22/25.
//

import ComposableArchitecture

@Reducer
struct QuestionListFeature {
    
    @ObservableState
    struct State: Equatable {
        var questionList: [Question] = []
        var totalCount: QappleAPI.TotalCount = 0
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case onAppear
        case refresh
        case pagination
        case questionListResponse([Question], QappleAPI.TotalCount, QappleAPI.PaginationInfo)
        case paginationResponse([Question], QappleAPI.PaginationInfo)
        case networkingFailed(Error)
        case questionCellTapped(Question)
        case answerButtonTapped(Question)
        case toggleLoading(Bool)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.questionRepository.fetchQuestionList) var fetchQuestionList
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await fetchQuestionList(nil)
                        await send(.questionListResponse(response.0, response.1, response.2))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .pagination:
                return .run { [threshold = state.paginationInfo.threshold] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await fetchQuestionList(threshold)
                        await send(.paginationResponse(response.0, response.2))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .questionListResponse(questionList, totalCount, paginationInfo):
                state.questionList = questionList
                state.totalCount = totalCount
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginationResponse(questionList, paginationInfo):
                state.questionList += questionList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .questionCellTapped(question):
                if !question.isAnswered {
                    HapticService.notification(type: .warning)
                    state.alert = .answeringCheck
                }
                return .none
                
            case .answerButtonTapped:
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Alert

extension AlertState where Action == QuestionListFeature.Action.Alert {
    static let answeringCheck = AlertState {
        TextState("답변하면 확인이 가능해요 😀")
    } actions: {
        ButtonState(role: .none) {
            TextState("확인")
        }
    } message: {
        TextState("즐거운 커뮤니티 운영을 위해\n여러분의 답변을 들려주세요")
    }
}
