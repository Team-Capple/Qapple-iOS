//
//  ProfileFeature.swift
//  Qapple
//
//  Created by Simmons on 1/30/25.
//

import Foundation
import ComposableArchitecture
import MessageUI

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.inMemory(Constant.isSignIn)) var isSignIn = false
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
        var nickname: String = ""
        var joinDate: String = ""
        var profileImage: String?
        var isLoading = false
    }
    
    enum Action {
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        case getProfile
        case fetchProfile(MyProfile)
        
        case editProfileButtonTapped(nickname: String)
        case myAnswerListButtonTapped
        case inquiryButtonTapped
        case peopleWhoMadeQappleButtonTapped
        case logOutButtonTapped
        case resignButtonTapped
        case networkingFailed(Error)
        case toggleLoading(Bool)
        
        enum Alert {
            case confirmEmailDisabled
            case confirmLogOut
            case confirmResign
        }
        
        enum Delegate {
            case confirmEmailDisabled
            case confirmLogOut
            case confirmResign
        }
    }
    
    @Dependency(\.memberRepository) var memberRepository
    @Dependency(\.keychainService) var keychainService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sheet(.presented(.inquiryButtonTap)):
                return .none
                
            case .alert(.presented(.confirmEmailDisabled)):
                return .run { send in
                    await send(.delegate(.confirmEmailDisabled))
                }
                
            case .alert(.presented(.confirmLogOut)):
                return .run { [isSignIn = state.$isSignIn] send in
                    do {
                        isSignIn.withLock { $0 = false }
                        try keychainService.createData(.userId, "")
                    } catch {
                        await send(.networkingFailed(error))
                    }
                }
                
            case .alert(.presented(.confirmResign)):
                return .run { [isSignIn = state.$isSignIn] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await memberRepository.resign()
                        isSignIn.withLock { $0 = false }
                        try keychainService.createData(.userId, "")
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .getProfile:
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let data = try await memberRepository.fetchMyPage()
                        await send(.fetchProfile(data))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .fetchProfile(profile):
                state.nickname = profile.nickname
                state.joinDate = profile.joinDate
                if let profileImage = profile.profileImage {
                    state.profileImage = profileImage
                }
                return .none
                
            case .editProfileButtonTapped:
                return .none
                
            case .myAnswerListButtonTapped:
                return .none
                
            case .inquiryButtonTapped:
                if !MFMailComposeViewController.canSendMail() {
                    state.alert = .confirmEmailDisabled
                } else {
                    state.sheet = .inquiryButtonTap
                }
                return .none
                
            case .peopleWhoMadeQappleButtonTapped:
                return .none
                
            case .logOutButtonTapped:
                HapticService.notification(type: .warning)
                state.alert = .confirmLogout
                return .none
                
            case .resignButtonTapped:
                HapticService.notification(type: .warning)
                state.alert = .confirmResign
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case .alert, .sheet, .delegate:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - ProfileSheet

extension ProfileFeature {
    @Reducer
    enum Sheet {
        case inquiryButtonTap
    }
}

extension ProfileFeature.Sheet.State: Equatable {}

// MARK: - ProfileAlert

extension AlertState where Action == ProfileFeature.Action.Alert {
    static let confirmEmailDisabled = Self {
        TextState("메일 앱에 로그인할 수 없어요")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("메일 앱에 로그인하거나\n공식 메일 주소로 문의주세요\n(0.team.capple@gmail.com)")
    }
    
    static let confirmLogout = Self {
        TextState("로그아웃 할까요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .confirmLogOut) {
            TextState("로그아웃")
        }
    } message: {
        TextState("언제든 다시 돌아올 수 있습니다!")
    }
    
    static let confirmResign = Self {
        TextState("정말 탈퇴하시겠어요?")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("취소")
        }
        ButtonState(role: .destructive, action: .confirmResign) {
            TextState("회원 탈퇴")
        }
    } message: {
        TextState("탈퇴하면 계정은 복구되지 않아요\n단, 이미 작성한 답변은 남아있어요")
    }
}
