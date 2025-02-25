//
//  ProfileEditFeature.swift
//  Qapple
//
//  Created by Simmons on 2/1/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileEditFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        let textLimit = 15
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        var nickname: String
        var defaultNickname: String
        var nicknameCheck: Bool = true
        var nicknameFieldAvailable: Bool = true
        var nicknameChange: Bool = false
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case alert(PresentationAction<Alert>)
        
        case backButtonTapped
        case successButtonTapped
        case nicknameCheckButtonTapped
        case failEdit
        case toggleNicknameCheck(Bool)
        case toggleNicknameChange(Bool)
        case binding(BindingAction<State>)
        case nicknameChanged(String)
        case networkingFailed(Error)
        case toggleLoading(Bool)
        
        enum Alert {
            case confirmFailEdit
        }
    }
    
    @Dependency(\.memberRepository) var memberRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .successButtonTapped:
                let nickname = state.nickname
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await memberRepository.editMyPage(nickname, nil)
                        await dismiss()
                    } catch {
                        await send(.failEdit)
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .nicknameCheckButtonTapped:
                let nickname = state.nickname
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let data = try await memberRepository.checkNicknameDuplicate(nickname)
                        await send(.toggleNicknameCheck(!data))
                        await send(.toggleNicknameChange(false))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .failEdit:
                state.alert = .confirmFailEdit
                return .none
                
            case let .toggleNicknameCheck(bool):
                state.nicknameCheck = bool
                return .none
                
            case let .toggleNicknameChange(bool):
                state.nicknameChange = bool
                return .none
                
            case .binding(\.nickname):
                return .none
                
            case let .nicknameChanged(nickname):
                state.nickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if state.nickname.count > state.textLimit {
                    state.nickname = String(state.nickname.prefix(state.textLimit))
                }
                
                if let regex = try? NSRegularExpression(pattern: state.pattern, options: .caseInsensitive) {
                    let range = NSRange(location: 0, length: state.nickname.utf16.count)
                    if regex.firstMatch(in: state.nickname, options: [], range: range) != nil {
                        state.nicknameFieldAvailable = true
                    } else {
                        state.nicknameFieldAvailable = false
                    }
                }
                
                return .run { [defaultNickname = state.defaultNickname] send in
                    if defaultNickname == nickname {
                        await send(.toggleNicknameCheck(true))
                        await send(.toggleNicknameChange(false))
                    } else {
                        await send(.toggleNicknameChange(true))
                    }
                }
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .alert, .binding:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - ProfileEditAlert

extension AlertState where Action == ProfileEditFeature.Action.Alert {
    static let confirmFailEdit = Self {
        TextState("회원 정보 수정에 실패했습니다")
    } actions: {
        ButtonState(role: .cancel){
            TextState("확인")
        }
    } message: {
        TextState("다시 요청해주세요")
    }
}
