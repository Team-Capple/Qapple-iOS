//
//  MainFlowView.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import ComposableArchitecture
import SwiftUI

struct MainFlowView: View {
    
    @Bindable var store: StoreOf<MainFlowFeature>
    
    @State private var tab: MainFlowFeature.MainFlowTab = .question
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TabView(selection: $tab) {
                QuestionTabView(store: store.scope(state: \.questionTab, action: \.questionTab))
                    .tag(MainFlowFeature.MainFlowTab.question)
                    .tabItem {
                        Image(systemName: "questionmark.bubble.fill")
                        Text("오늘의 질문")
                    }
                
                BulletinBoardView(store: store.scope(state: \.bulletinBoardTab, action: \.bulletinBoardTab))
                    .tag(MainFlowFeature.MainFlowTab.bulletinBoard)
                    .tabItem {
                        Image(systemName: "list.clipboard.fill")
                        Text("게시판")
                    }
                
                ProfileView(store: store.scope(state: \.profileTab, action: \.profileTab))
                    .tag(MainFlowFeature.MainFlowTab.profile)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("내 정보")
                    }
            }
            .tint(.button)
            .fixedTabBarBackground(color: .first)
            .onChange(of: tab) {
                HapticService.impact(style: .soft)
            }
        } destination: { store in
            switch store.case {
            case let .writeAnswer(store): WriteAnswerView(store: store)
            case let .completeAnswer(store): CompleteAnswerView(store: store)
            case let .answerList(store): AnswerListView(store: store)
            case let .answerCommentList(store): AnswerCommentView(store: store)
            case let .bulletinBoard(store): BulletinBoardView(store: store)
            case let .bulletinBoardSearch(store): BulletinBoardSearchView(store: store)
            case let .bulletinBoardPost(store): BulletinBoardPostView(store: store)
            case let .comment(store): BoardCommentView(store: store)
            case let .profileEdit(store): ProfileEditView(store: store)
            case let .myAnswerList(store): MyAnswerListView(store: store)
            case .peopleWhoMadeQapple: PeopleWhoMadeQappleView()
            case let .notificationList(store): NotificationListView(store: store)
            case let .report(store): ReportView(store: store)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MainFlowView(store: Store(initialState: MainFlowFeature.State()) {
        MainFlowFeature()
    })
}
