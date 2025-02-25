//
//  BulletinBoardFeature.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BulletinBoardFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var sheet: Sheet.State?
        @Presents var alert: AlertState<Action.Alert>?
        var bulletinBoardList: [BulletinBoard] = []
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var academyEvents: [AcademyEvent] = [.macro, .epilogue]
        var isLoading: Bool = false
    }
    
    enum Action {
        case onAppear
        case refresh
        case pagination
        case bulletinBoardListResponse([BulletinBoard], QappleAPI.PaginationInfo)
        case paginationResponse([BulletinBoard], QappleAPI.PaginationInfo)
        
        case boardCellTapped(BulletinBoard)
        case reportButtonTapped
        case likeBoardButtonTapped(BulletinBoard)
        case likeBoard(Int)
        case deleteBoard(Int)
        case searchButtonTapped
        case notificationButtonTapped
        case postBoardButtonTapped
        case seeMoreAction(BulletinBoard)
        case networkingFailed(Error)
        case toggleLoading(Bool)
        
        case sheet(PresentationAction<Sheet.Action>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        
        enum Alert {
            case confirmReport
        }
        
        enum Delegate {
            case confirmReport
        }
    }
    
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state,action in
            switch action {
            case .onAppear, .refresh:
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await bulletinBoardRepository.fetchBulletinBoardList(nil)
                        await send(.bulletinBoardListResponse(response.0, response.1))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .pagination:
                return .run { [threshold = Int(state.paginationInfo.threshold)] send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        let response = try await bulletinBoardRepository.fetchBulletinBoardList(threshold)
                        await send(.paginationResponse(response.0, response.1))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .bulletinBoardListResponse(bulletinBoardList, paginationInfo):
                state.bulletinBoardList = bulletinBoardList
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginationResponse(bulletinBoardList, paginationInfo):
                state.bulletinBoardList += bulletinBoardList
                state.paginationInfo = paginationInfo
                return .none
                
            case .boardCellTapped:
                return .none
                
            case .reportButtonTapped:
                HapticService.notification(type: .warning)
                state.alert = .confirmReport
                return .none
                
            case let .likeBoardButtonTapped(board):
                HapticService.impact(style: .light)
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.likeBoard(board.id)
                        await send(.likeBoard(board.id))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case let .likeBoard(boardId):
                if let index = state.bulletinBoardList.firstIndex(where: {$0.id == boardId}) {
                    state.bulletinBoardList[index].isLiked.toggle()
                    state.bulletinBoardList[index].heartCount += state.bulletinBoardList[index].isLiked ? 1 : -1
                }
                return .none
                
            case let .deleteBoard(boardId):
                if let index = state.bulletinBoardList.firstIndex(where: {$0.id == boardId}) {
                    state.bulletinBoardList.remove(at: index)
                }
                return .none
                
            case .searchButtonTapped:
                return .none
                
            case .notificationButtonTapped:
                return .none
                
            case .postBoardButtonTapped:
                return .none
                
            case let .seeMoreAction(board):
                state.sheet = .seeMore(
                    .init(
                        sheetTarget: board.isMine ? .mine : .others,
                        dataType: .bulletinBoard(board)
                    )
                )
                return .none
                
            case let .networkingFailed(error):
                HapticService.notification(type: .error)
                state.alert = .failedNetworking(with: error)
                return .none
                
            case let .toggleLoading(bool):
                state.isLoading = bool
                return .none
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmDeletion(sheetData)))))):
                guard case let .bulletinBoard(board) = sheetData else { return .none }
                return .run { send in
                    await send(.toggleLoading(true), animation: .bouncy)
                    do {
                        try await bulletinBoardRepository.deleteBoard(board.id)
                        await send(.deleteBoard(board.id))
                        await send(.sheet(.presented(.seeMore(.completionDeletion))))
                    } catch {
                        await send(.networkingFailed(error))
                    }
                    await send(.toggleLoading(false), animation: .bouncy)
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmCompletion))))):
                state.sheet = nil
                return .none
                
            case .sheet(.presented(.seeMore(.reportButtonTapped))):
                state.sheet = nil
                return .none
                
            case .alert(.presented(.confirmReport)):
                return .run { send in
                    await send(.delegate(.confirmReport))
                }
                
            case .sheet, .alert, .delegate:
                return .none
            }
        }
        .ifLet(\.$sheet, action: \.sheet)
        .ifLet(\.$alert, action: \.alert)
    }
}

// MARK: - BulletinBoardSheet

extension BulletinBoardFeature {
    @Reducer(state: .equatable)
    enum Sheet {
        case seeMore(SeeMoreSheetFeature)
    }
}

// MARK: - BulletinBoardAlert

extension AlertState where Action == BulletinBoardFeature.Action.Alert {
    static let confirmReport = Self {
        TextState("신고된 게시글")
    } actions: {
        ButtonState(role: .cancel) {
            TextState("확인")
        }
    } message: {
        TextState("신고된 게시글은 열람할 수 없습니다.")
    }
}
