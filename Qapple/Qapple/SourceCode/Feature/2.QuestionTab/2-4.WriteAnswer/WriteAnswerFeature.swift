//
//  WriteAnswerFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct WriteAnswerFeature {
    
    @ObservableState
    struct State: Equatable {
        var question: Question
        let textLimit = 250
        var answerText: String = ""
        var answerTextFontSize: CGFloat = 48
        var isLoading = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: BindableAction {
        case typeAnswerText(String)
        case anonymityNoticeButtonTapped
        case dismissButtonTapped
        case completeButtonTapped
        case postAnswerResponse(Question)
        case networkingFailed(Error)
        case toggleLoading(Bool)
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        enum Alert: Equatable {
            case stopAnswering
        }
    }
    
    @Dependency(\.answerRepository.postAnswer) var postAnswer
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .typeAnswerText(text):
                state.answerText = text.slice(to: state.textLimit)
                state.answerTextFontSize = adaptiveFontSize(from: text)
                return .none
                
            case .anonymityNoticeButtonTapped:
                state.sheet = .anonymityNotice
                return .none
                
            case .dismissButtonTapped:
                if state.answerText.isEmpty {
                    return .run { send in
                        await dismiss()
                    }
                } else {
                    HapticService.notification(type: .warning)
                    state.alert = .stopAnswering
                    return .none
                }
                
            case .completeButtonTapped:
                guard !state.answerText.isEmpty else { return .none }
                return .run { [state = state] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await postAnswer(state.question.id, state.answerText)
                        await send(.postAnswerResponse(state.question))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .alert(.presented(.stopAnswering)):
                return .run { send in
                    await dismiss()
                }
                
            case .postAnswerResponse:
                HapticService.notification(type: .success)
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.answerText):
                return .none
                
            case .sheet, .alert, .binding:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - Sheet

extension WriteAnswerFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case anonymityNotice
    }
}

// MARK: - Alert

extension AlertState where Action == WriteAnswerFeature.Action.Alert {
    static let stopAnswering = AlertState {
        TextState("정말 그만두시겠어요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .stopAnswering) {
            TextState("그만두기")
        }
    } message: {
        TextState("지금까지 작성한 답변이 사라져요")
    }
}
