//
//  SocialLoginFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import AuthenticationServices

@Reducer
struct SocialLoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case appleLoginOnRequest(ASAuthorizationAppleIDRequest)
        case appleLoginOnCompletion(Result<ASAuthorization, Error>)
        case networkingFailed(Error)
        case toggleLoading(Bool)
        case delegate(Delegate)
        
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
        
        enum Delegate {
            case signInResponse(Bool)
        }
    }
    
    @Dependency(\.appleLoginService) var appleLoginService
    @Dependency(\.memberRepository) var memberRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .appleLoginOnRequest(request):
                appleLoginService.requestLogin(request)
                return .none
                
            case let .appleLoginOnCompletion(result):
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let authCode = try await appleLoginService.loginCompletion(result)
                        let isSignUp = try await memberRepository.signIn(authCode)
                        await send(.delegate(.signInResponse(isSignUp)))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .alert, .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
