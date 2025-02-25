//
//  NotificationFeature.swift
//  Qapple
//
//  Created by 문인범 on 1/26/25.
//

import Foundation
import ComposableArchitecture


@Reducer
struct NotificationFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?

        var notifications = [QappleNotification]()
        
        var isLoading: Bool = false
        
        var threshold: Int?
        var hasNext: Bool = false
    }
    
    enum Action {
        case onAppear
        case onRefresh
        case onPagenationCellAppear(Int)
        case notificationCellTapped(Int)
        case reportedBoard
        case unknownError
        case networkingFailed(Error)
        
        case backButtonTapped
        
        case fetchNotifications([QappleNotification], QappleAPI.PaginationInfo)
        
        case navigateToComment(BulletinBoard)
        case navigateToWriteAnswer(Question)
        case navigateToAnswerList(Question)
        
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {}
    }
    
    @Dependency(\.notificationRepository) var notificationRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .onRefresh:
                state.isLoading = true
                
                state.notifications.removeAll()
                state.threshold = nil
                state.hasNext = false
                return .run { send in
                    do {
                        let result = try await notificationRepository.fetchNotificationList(nil)
                        await send(.fetchNotifications(result.0, result.1))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                }
                
            case let .onPagenationCellAppear(index):
                guard state.hasNext, index == state.notifications.count - 1 else { return .none }
                state.isLoading = true
                
                return .run { [threshold = state.threshold] send in
                    let result = try await notificationRepository.fetchNotificationList(threshold)
                    await send(.fetchNotifications(result.0, result.1))
                }
                
            case let .fetchNotifications(notifications, pagenationInfo):
                state.threshold = Int(pagenationInfo.threshold)
                state.hasNext = pagenationInfo.hasNext
                state.notifications.append(contentsOf: notifications)
                
                state.isLoading = false
                return .none
                
            case let .notificationCellTapped(index):
                state.isLoading = true
                return .run { [noti = state.notifications[index] ] send in
                    // 게시판 관련 알림일때
                    if let boardId = Int(noti.boardId) {
                        do {
                            let result = try await notificationRepository.fetchSingleBoard(boardId)
                            
                            // 신고된 게시물일 경우
                            if result.isReported { await send(.reportedBoard) }
                            else {
                                await send(.navigateToComment(result))
                            }
                        } catch {
                            await send(.unknownError)
                        }
                    // 질문 관련 알림일때
                    } else if let questionId = Int(noti.id) {
                        do {
                            let result = try await notificationRepository.isAnsweredQuestion(questionId)
                            
                            if result.0 {
                                await send(.navigateToAnswerList(result.1))
                            } else {
                                await send(.navigateToWriteAnswer(result.1))
                            }
                        } catch {
                            await send(.unknownError)
                        }
                        
                    }
                }
                
            case .navigateToComment:
                state.isLoading = false
                return .none
            case .navigateToWriteAnswer:
                state.isLoading = false
                return .none
            case .navigateToAnswerList:
                state.isLoading = false
                return .none
                
            case .reportedBoard:
                state.isLoading = false
                state.alert = .reportedBoard
                return .none
                
            case .unknownError:
                state.isLoading = false
                state.alert = .unknownError
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case .backButtonTapped:
                return .run { send in
                    await dismiss()
                }
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
}


extension AlertState where Action == NotificationFeature.Action.Alert {
    static let reportedBoard = Self {
        TextState("신고된 게시글")
    } actions: {
        ButtonState(role: .none, label: { TextState("확인") })
    } message: {
        TextState("신고된 게시글은 열람할 수 없습니다.")
    }
    
    static let unknownError = Self {
        TextState("알 수 없는 오류가 발생했습니다.")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("잠시후 다시 시도해주세요.")
    }
}
