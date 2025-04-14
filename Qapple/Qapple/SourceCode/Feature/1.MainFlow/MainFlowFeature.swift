//
//  MainFlowFeature.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import ComposableArchitecture

@Reducer
struct MainFlowFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared(.inMemory(Constant.isSignIn)) var isSignIn = false
        var questionTab = QuestionTabFeature.State()
        var bulletinBoardTab = BulletinBoardFeature.State()
        var profileTab = ProfileFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case questionTab(QuestionTabFeature.Action)
        case bulletinBoardTab(BulletinBoardFeature.Action)
        case profileTab(ProfileFeature.Action)
        
        case pushToAnswerList(Question)
        case pushToWriteAnswer(Question)
        case pushToComment(BulletinBoard)
        case refreshTokenFailed
        
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.questionTab, action: \.questionTab) {
            QuestionTabFeature()
        }
        Scope(state: \.bulletinBoardTab, action: \.bulletinBoardTab) {
            BulletinBoardFeature()
        }
        Scope(state: \.profileTab, action: \.profileTab) {
            ProfileFeature()
        }
        Reduce { state, action in
            switch action {
            case let .questionTab(.todayQuestion(.questionButtonTapped(question))):
                if question.isAnswered {
                    state.path.append(.answerList(.init(question: question)))
                } else {
                    state.path.append(.writeAnswer(.init(question: question)))
                }
                return .none
                
            case let .questionTab(.todayQuestion(.seeAllAnswerButtonTapped(question))):
                state.path.append(.answerList(.init(question: question)))
                return .none
                
            case let .questionTab(.questionList(.questionCellTapped(question))):
                if question.isAnswered {
                    state.path.append(.answerList(.init(question: question)))
                }
                return .none
                
            case let .questionTab(.questionList(.answerButtonTapped(question))):
                state.path.append(.writeAnswer(.init(question: question)))
                return .none
                
            case .questionTab(.notificationButtonTapped):
                state.path.append(.notificationList(.init()))
                return .none
                
            case let .questionTab(.todayQuestion(.sheet(.presented(.seeMore(.reportButtonTapped(dataType)))))):
                state.path.append(.report(.init(dataType: dataType)))
                return .none
                
            case let .questionTab(.todayQuestion((.answerCommentButtonTapped(answer)))):
                state.path.append(.answerCommentList(.init(answer: answer)))
                return .none
                
            case let .bulletinBoardTab(.boardCellTapped(board)):
                state.path.append(.comment(.init(board: board)))
                return .none
                
            case .bulletinBoardTab(.notificationButtonTapped):
                state.path.append(.notificationList(.init()))
                return .none
                
            case .bulletinBoardTab(.searchButtonTapped):
                state.path.append(.bulletinBoardSearch(.init()))
                return .none
                
            case .bulletinBoardTab(.postBoardButtonTapped):
                state.path.append(.bulletinBoardPost(.init()))
                return .none
                
            case let .bulletinBoardTab(.sheet(.presented(.seeMore(.reportButtonTapped(dataType))))):
                state.path.append(.report(.init(dataType: dataType)))
                return .none
            case let .profileTab(.editProfileButtonTapped(nickname)):
                state.path.append(.profileEdit(.init(nickname: nickname, defaultNickname: nickname)))
                return .none
                
            case .profileTab(.myAnswerListButtonTapped):
                state.path.append(.myAnswerList(.init()))
                return .none
                
            case .profileTab(.peopleWhoMadeQappleButtonTapped):
                state.path.append(.peopleWhoMadeQapple)
                return .none
                
            case let .pushToAnswerList(question):
                state.path.append(.answerList(.init(question: question)))
                return .none
                
            case let .pushToWriteAnswer(question):
                state.path.append(.writeAnswer(.init(question: question)))
                return .none
                
            case let .pushToComment(board):
                state.path.append(.comment(.init(board: board)))
                return .none
                
            case .refreshTokenFailed:
                state.$isSignIn.withLock { $0 = false }
                state.path.removeAll()
                return .none
                
            case let .path(stackAction):
                switch stackAction {
                case let .element(id: _, action: .writeAnswer(.postAnswerResponse(question))):
                    state.path.append(.completeAnswer(.init(question: question)))
                    return .none
                    
                case let .element(id: _, action: .completeAnswer(.confirmButtonTapped(question))):
                    state.path.removeAll()
                    state.path.append(.answerList(.init(question: question)))
                    return .none
                    
                case let .element(id: _, action: .answerList(.sheet(.presented(.seeMore(.reportButtonTapped(dataType)))))):
                    state.path.append(.report(.init(dataType: dataType)))
                    return .none
                    
                case let .element(id: _, action: .answerCommentList(.sheet(.presented(.seeMore(.reportButtonTapped(dataType)))))):
                    state.path.append(.report(.init(dataType: dataType)))
                    return .none
                    
                case let .element(id: _, action: .answerCommentList(.reportButtonTapped(answerComment))):
                    state.path.append(.report(.init(dataType: .answerComment(answerComment))))
                    return .none
                    
                case let .element(id: _, action: .bulletinBoardSearch(.sheet(.presented(.seeMore(.reportButtonTapped(dataType)))))):
                    state.path.append(.report(.init(dataType: dataType)))
                    return .none
                    
                case let .element(id: _, action: .comment(.reportButtonTapped(comment))):
                    state.path.append(.report(.init(dataType: .comment(comment))))
                    return .none
                    
                case let .element(id: _, action: .comment(.sheet(.presented(.seeMore(.reportButtonTapped(dataType)))))):
                    state.path.append(.report(.init(dataType: dataType)))
                    return .none
                    
                case let .element(id: _, action: .report(.alert(.presented(.confirmCompletion(dataType))))):
                    let previousPath = state.path.dropLast().last
                    
                    if case .comment = previousPath, case .bulletinBoard = dataType {
                        state.path.removeLast(2)
                    } else {
                        state.path.removeLast()
                    }
                    return .none
                  
                case let .element(id: _, action: .notificationList(.navigateToComment(board))):
                    state.path.append(.comment(.init(board: board)))
                    return .none
                    
                case let .element(id: _, action: .notificationList(.navigateToWriteAnswer(question))):
                    state.path.append(.writeAnswer(.init(question: question)))
                    return .none
                    
                case let .element(id: _, action: .notificationList(.navigateToAnswerList(question))):
                    state.path.append(.answerList(.init(question: question)))
                    return .none
                    
                case let .element(id: _, action: .bulletinBoardSearch(.boardCellTapped(board))):
                    state.path.append(.comment(.init(board: board)))
                    return .none
                    
                case .element(id: _, action: .answerList(.backButtonTapped)):
                    state.path.removeAll()
                    return .none
                    
                case .element(id: _, action: .answerList(.onDisappear)):
                    state.path.removeAll()
                    return .none
                    
                case .element(id: _, action: .comment(.onDisappear)):
                    state.path.removeAll()
                    return .none
                    
                default:
                    return .none
                }
                
            default: return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path

extension MainFlowFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case writeAnswer(WriteAnswerFeature)
        case completeAnswer(CompleteAnswerFeature)
        case answerList(AnswerListFeature)
        case answerCommentList(AnswerCommentFeature)
        case bulletinBoard(BulletinBoardFeature)
        case bulletinBoardSearch(BulletinBoardSearchFeature)
        case bulletinBoardPost(BulletinBoardPostFeature)
        case comment(CommentFeature)
        case profileEdit(ProfileEditFeature)
        case myAnswerList(MyAnswerListFeature)
        case peopleWhoMadeQapple
        case notificationList(NotificationFeature)
        case report(ReportFeature)
    }
}

// MARK: - MainFlowTab

extension MainFlowFeature {
    
    enum MainFlowTab {
        case question
        case bulletinBoard
        case profile
    }
}
