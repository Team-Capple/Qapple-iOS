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
        var todayQuestion: Question = .initialState
        var event: AcademyEventFor4th = .fourthStart
        var popularAnswerStatus: PopularAnswerCellStatus = .none
        var paginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: false)
        var isLoading: Bool = false
        var isFirstLaunch = true
    }
    
    enum Action {
        case onAppear
        case active
        case refresh
        case pagination
        case bulletinBoardListResponse(Question, [BulletinBoard], QappleAPI.PaginationInfo)
        case paginationResponse([BulletinBoard], QappleAPI.PaginationInfo)
        
        case academyDayCounterTapped
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
        case filterBlockedUser

        case questionNotiTapped(Question)
        case popularAnswerTapped(Question)
        case fetchPopularAnswer((Answer?, Question?, Bool))
        
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
    
    @Dependency(\.questionRepository.fetchMainQuestion) var fetchMainQuestion
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    @Dependency(\.answerRepository.fetchPopularAnswer) var fetchPopularAnswer
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .active, .refresh:
                if let currentEvent = AcademyEventFor4th.currentEvent {
                    state.event = currentEvent
                }
                return .run { [isFirstLaunch = state.isFirstLaunch] send in
                    if isFirstLaunch { await send(.toggleLoading(true), animation: .bouncy) }
                    do {
                        let mainQuestion = try await fetchMainQuestion()
                        let response = try await bulletinBoardRepository.fetchBulletinBoardList(nil)
                        let popularAnswer = try await fetchPopularAnswer(nil)
                        await send(.fetchPopularAnswer(popularAnswer))
                        await send(.bulletinBoardListResponse(mainQuestion, response.0, response.1))
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
                
            case let .bulletinBoardListResponse(mainQuestion, bulletinBoardList, paginationInfo):
                state.todayQuestion = mainQuestion
                state.isFirstLaunch = false
                state.bulletinBoardList = bulletinBoardList.filter(UserDefaults.filterBoardBlockedUser)
                state.paginationInfo = paginationInfo
                return .none
                
            case let .paginationResponse(bulletinBoardList, paginationInfo):
                state.bulletinBoardList += bulletinBoardList.filter(UserDefaults.filterBoardBlockedUser)
                state.paginationInfo = paginationInfo
                return .none
                
            case .academyDayCounterTapped:
                HapticService.impact(style: .light)
                GAService.log(.checkAcademySchedule(event: .currentEvent ?? (.nextEvent ?? .prelude)))
                state.sheet = .academySchedule
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
                        if !board.isLiked { GAService.log(.likeBoardFromList(board: board)) }
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
                
            case let .fetchPopularAnswer(result):
                if let answer = result.0, let question = result.1 {
                    state.popularAnswerStatus = .popularAnswer(answer, question)
                } else {
                    state.popularAnswerStatus = result.2 ? .none : .todayQuestion
                }
                
                return .none
                
            case .searchButtonTapped:
                return .none
                
            case .notificationButtonTapped:
                return .none
                
            case .postBoardButtonTapped:
                return .none
                
            case .questionNotiTapped:
                return .none
                
            case .popularAnswerTapped:
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
                
            case let .sheet(.presented(.seeMore(.alert(.presented(.confirmBlockUser(sheetData)))))):
                guard case let .bulletinBoard(board) = sheetData else { return .none }
                return .run { send in
                    UserDefaults.addBlockedUser(board.writerId)
                    await send(.sheet(.presented(.seeMore(.completionBlocking))))
                }
                
            case .sheet(.presented(.seeMore(.alert(.presented(.confirmBlockCompletion))))):
                state.sheet = nil
                return .send(.filterBlockedUser)
                
            case .filterBlockedUser:
                state.bulletinBoardList = state.bulletinBoardList.filter(UserDefaults.filterBoardBlockedUser)
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
        case academySchedule
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
