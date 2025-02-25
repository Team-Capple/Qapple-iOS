//
//  SignUpFlowFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture

@Reducer
struct SignUpFlowFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared(.inMemory(Constant.isSignIn)) var isSignIn = false
        @Presents var alert: AlertState<Action.Alert>?
        var isFirstLaunch = true
        var socialLogin = SocialLoginFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case onAppear
        case autoLoginResponse
        case socialLogin(SocialLoginFeature.Action)
        case networkingFailed(Error)
        case path(StackActionOf<Path>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.appleLoginService) var appleLoginService
    
    var body: some ReducerOf<Self> {
        Scope(state: \.socialLogin, action: \.socialLogin) {
            SocialLoginFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.isFirstLaunch else { return .none }
                return .run { send in
                    do {
                        try await appleLoginService.autoLogin()
                        await send(.autoLoginResponse)
                    } catch {
                        await send(.networkingFailed(error))
                    }
                }
                
            case .autoLoginResponse:
                state.isFirstLaunch = false
                state.$isSignIn.withLock { $0 = true }
                return .none
                
            case let .socialLogin(.delegate(.signInResponse(isSignUp))):
                if isSignUp {
                    state.isFirstLaunch = false
                    state.$isSignIn.withLock { $0 = true }
                    HapticService.notification(type: .success)
                } else {
                    state.path.append(.emailForm(.init()))
                }
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .path(stackAction):
                switch stackAction {
                case let .element(id: _, action: .emailForm(.sendCertificationEmailResponse(email))):
                    state.path.append(.authCodeForm(.init(emailText: email)))
                    return .none
                    
                case let .element(id: _, action: .authCodeForm(.authCodeFormComplete(email))):
                    state.path.append(.nicknameForm(.init(emailText: email)))
                    return .none
                    
                case let .element(id: _, action: .nicknameForm(.nicknameFormComplete(email, nickname))):
                    state.path.append(.termsAgreement(.init(emailText: email, nicknameText: nickname)))
                    return .none
                    
                case .element(id: _, action: .termsAgreement(.signUpResponse)):
                    state.path.append(.signUpComplete(.init()))
                    HapticService.notification(type: .success)
                    return .none
                    
                case .element(id: _, action: .signUpComplete(.startButtonTapped)):
                    state.$isSignIn.withLock { $0 = true }
                    state.path.removeAll()
                    return .none
                    
                default:
                    return .none
                }
                
            case .alert:
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path

extension SignUpFlowFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case emailForm(EmailFormFeature)
        case authCodeForm(AuthCodeFormFeature)
        case nicknameForm(NicknameFormFeature)
        case termsAgreement(TermsAgreementFeature)
        case signUpComplete(SignUpCompleteFeature)
    }
}
