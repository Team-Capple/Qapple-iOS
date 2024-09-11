//
//  NavigationRouter.swift
//  Qapple
//
//  Created by 문인범 on 8/18/24.
//

import SwiftUI

/**
 Navigation path를 관리하는 클래스
 */
final class Router: ObservableObject, NavigationRouter {
    @Published public var route: NavigationPath = .init()
    
    /// Tab 구분을 위한 타입 지정
    private var pathType: TabPathType
    
    /// path 추가
    func pushView<T: Hashable>(screen: T) {
        self.route.append(screen)
    }
    
    /// path 제거
    func pop() {
        self.route.removeLast()
    }
    
    /// 최상위 뷰로 이동
    func popToRoot() {
        self.route = .init()
    }
    
    init(pathType: TabPathType) {
        self.pathType = pathType
    }
    
    func updatePathType(to pathType: TabPathType) {
        self.pathType = pathType
    }
    
    @ViewBuilder
    public func getNavigationDestination(
        answerViewModel: AnswerViewModel? = nil,
        view: AnyHashable
    ) -> some View {
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
            case .todayAnswer(questionId: let questionId, questionContent: let questionContent):
                AnswerListView(questionId: questionId, questionContent: questionContent)
            case .alert:
                AlertView()
            case .report(answerId: let answerId):
                ReportView(answerId: answerId)
            }
        } else if pathType == .bulletinBoard {
            let view = view as! BulletinBoardPathType
            
            switch view {
            case .bulletinSearch:
                BulletinSearchView()
            case .bulletinPosting:
                BulletinPostingView()
            case .alert:
                NotificationListView()
            case .search:
                BulletinSearchView()
            case .comment(post: let post):
                CommentView(post: post)
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
    
    // Tab 구분을 위한 열거형
    enum TabPathType: Hashable {
        case questionList
        case bulletinBoard
        case myProfile

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


/// 질문리스트 Tab
enum QuestionListPathType: Hashable {
    /// 답변하기
    case answer(questionId: Int, questionContent: String) // 답변하기
    case confirmAnswer // 답변확인(키워드선택)
    case searchKeyword // 키워드 검색
    case completeAnswer // 답변 완료
    
    /// 모아보기
    case todayAnswer(questionId: Int, questionContent: String)
    
    /// 알림 및 신고
    case notifications
    case alert
    case report(answerId: Int)
}

/// 게시판 Tab
enum BulletinBoardPathType: Hashable {
    /// 게시판
    case bulletinSearch
    case bulletinPosting
    case alert
    case search
    case comment(post: Post)
}

/// 내 정보 Tab
enum MyProfilePathType: Hashable {
    /// 마이페이지
    case myPage
    case profileEdit(nickname: String)
    case writtenAnswer
}
