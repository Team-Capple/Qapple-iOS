//
//  NavigationRouter.swift
//  Qapple
//
//  Created by 문인범 on 8/18/24.
//

import SwiftUI


final class Router: ObservableObject, NavigationRouter {
    @Published public var route: NavigationPath = .init()
    
    private var pathType: TestPathType
    
    func pushView<T: Hashable>(screen: T) {
        self.route.append(screen)
    }
    
    func pop() {
        self.route.removeLast()
    }
    
    func popToRoot() {
        self.route = .init()
    }
    
    init(pathType: TestPathType) {
        self.pathType = pathType
    }
    
    @ViewBuilder
    public func getNavigationDestination(answerViewModel: AnswerViewModel? = nil, view: AnyHashable) -> some View {
        if pathType == .questionList {
            let view = view as! QuestionListPathType
            switch view {
            case .answer(let questionId, let questionContent):
                AnswerView(
                    viewModel: answerViewModel!,
                    questionId: questionId,
                    questionContent: questionContent
                )
            case .confirmAnswer:
                ConfirmAnswerView(viewModel: answerViewModel!)
            case .searchKeyword:
                SearchKeywordView(viewModel: answerViewModel!)
            case .completeAnswer:
                CompleteAnswerView(viewModel: answerViewModel!)
            case .notifications:
                NotificationListView()
            }
        } else if pathType == .bulletinBoard {
            let view = view as! BulletinBoardPathType
            
            switch view {
            case .bulletinSearch:
                BulletinSearchView()
            case .bulletinPosting:
                BulletinPostingView()
            }
        } else if pathType == .myProfile {
            let view = view as! MyProfilePathType
            
            switch view {
            case .myPage:
                MyPageView()
            case .profileEdit(let nickname):
                ProfileEditView(nickName: nickname)
            case .writtenAnswer:
                WrittenAnswerView()
            }
        } else {
            EmptyView()
        }
    }
}


protocol NavigationRouter {
    
    @MainActor
    func pushView<T: Hashable>(screen: T)
    
    @MainActor
    func pop()
    
    @MainActor
    func popToRoot()
}

