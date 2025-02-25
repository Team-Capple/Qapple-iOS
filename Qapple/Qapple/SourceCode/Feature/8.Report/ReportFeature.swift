//
//  ReportFeature.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import ComposableArchitecture
import QappleRepository

@Reducer
struct ReportFeature {
    
    @ObservableState
    struct State: Equatable {
        var dataType: DataType
        var isLoading = false
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case backButtonTapped
        case reportCellTapped(ReportType)
        case completionReport
        case networkingFailed(Error)
        case toggleLoading(Bool)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmReport(ReportType)
            case confirmCompletion(DataType)
        }
    }
    
    @Dependency(\.reportRepository) var reportRepository
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { send in await dismiss() }
                
            case let .reportCellTapped(reportType):
                HapticService.notification(type: .warning)
                state.alert = .reportCheck(from: state.dataType, type: reportType)
                return .none
                
            case let .alert(.presented(.confirmReport(reportType))):
                return .run { [dataType = state.dataType] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        switch dataType {
                        case let .answer(answer):
                            try await reportRepository.reportAnswer(answer.id, reportType)
                            
                        case let .bulletinBoard(board):
                            try await reportRepository.reportBoard(board.id, reportType)
                            
                        case let .comment(comment):
                            try await reportRepository.reportComment(comment.id, reportType)
                            
                        }
                        await send(.completionReport)
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .completionReport:
                state.alert = .reportComplete(from: state.dataType)
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
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

extension AlertState where Action == ReportFeature.Action.Alert {
    
    /// 신고 확인
    static func reportCheck(from dataType: DataType, type: ReportType) -> Self {
        let targetText = switch dataType {
        case .answer: "답변"
        case .bulletinBoard: "게시글"
        case .comment: "댓글"
        }
        return Self {
            TextState("\(targetText)을 신고하시겠어요?")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("취소")
            }
            ButtonState(role: .destructive, action: .confirmReport(type)) {
                TextState("신고하기")
            }
        }
    }
    
    /// 신고 완료
    static func reportComplete(from dataType: DataType) -> Self {
        let targetText = switch dataType {
        case .answer: "답변"
        case .bulletinBoard: "게시글"
        case .comment: "댓글"
        }
        return Self {
            TextState("\(targetText)이 신고되었어요")
        } actions: {
            ButtonState(role: .none, action: .confirmCompletion(dataType)) {
                TextState("확인")
            }
        } message: {
            TextState("신고한 \(targetText)은 블라인드 처리 되며, 관리자 검토 후 최대 24시간 이내에 조치 될 예정이에요")
        }
    }
}

