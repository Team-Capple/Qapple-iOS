//
//  BulletinBoardPostFeature.swift
//  Qapple
//
//  Created by Simmons on 1/28/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardPostFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
        var isLoading = false
        var boardText: String = ""
        var boardTextFontSize: CGFloat = 48
        var textCountLimit = 150
    }
    
    enum Action: BindableAction {
        case cancelButtonTapped
        case boardTextChanged
        case postBoardButtonTapped
        case anonymityNoticeButtonTapped
        case networkingFailed(Error)
        case toggleLoading(Bool)
        case binding(BindingAction<State>)
        
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        enum Alert {
            case confirmCancel
        }
        
        enum Delegate {
            case confirmCancel
        }
    }
    
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                if state.boardText.isEmpty {
                    return .run { send in
                        await dismiss()
                    }
                } else {
                    state.alert = .confirmCancel
                }
                return .none
                
            case .boardTextChanged:
                state.boardTextFontSize = adaptiveFontSize(from: state.boardText)
                if state.boardText.count > state.textCountLimit {
                    state.boardText = String(state.boardText.prefix(state.textCountLimit))
                }
                return .none
                
            case .postBoardButtonTapped:
                HapticService.notification(type: .success)
                let boardText = state.boardText
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.postBoard(boardText)
                        await dismiss()
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .anonymityNoticeButtonTapped:
                state.sheet = .anonymityNotice
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .binding(\.boardText):
                return .none
                
            case .alert(.presented(.confirmCancel)):
                return .run { send in
                    await send(.delegate(.confirmCancel))
                    await dismiss()
                }
                
            case .binding, .sheet, .alert, .delegate:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardSheet

extension BulletinBoardPostFeature {
    
    @Reducer(state: .equatable)
    enum Sheet {
        case anonymityNotice
    }
}

// MARK: - BulletinBoardPostAlert

extension AlertState where Action == BulletinBoardPostFeature.Action.Alert {
    static let confirmCancel = Self {
        TextState("정말 그만두시겠어요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .confirmCancel) {
            TextState("그만두기")
        }
    } message: {
        TextState("지금까지 작성한 답변이 사라져요")
    }
}
