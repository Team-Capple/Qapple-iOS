//
//  NotificationListView.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import SwiftUI

// MARK: - NotificationListView

struct NotificationListView: View {
    
    @StateObject private var notificationUseCase = NotificationUseCase()
    
    var body: some View {
        ZStack {
            Color(Background.first).ignoresSafeArea()
            
            NotificationContentView()
            
            if notificationUseCase.state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
        .environmentObject(notificationUseCase)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - NotificationContentView

private struct NotificationContentView: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var notificationUseCase: NotificationUseCase
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @State private var isReportedPostTappedAlert = false // 신고된 게시글 알림
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.pop()
                }},
                principalView: {
                    Text("알림")
                        .font(Font.pretendard(.semiBold, size: 17))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {},
                backgroundColor: Background.first)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(notificationUseCase.state.notificationList.enumerated()), id: \.offset) { index, notification in
                        
                        NotificationCell(notification: notification) {
                            print(pathModel.searchPathType())
                            if let boardId = Int(notification.boardId) {
                                Task {
                                    if let post = bulletinBoardUseCase.state.posts.first(where: { $0.boardId == boardId }) {
                                        if post.isReported {
                                            // 신고된 게시글이면 알림 표시
                                            isReportedPostTappedAlert.toggle()
                                        } else {
                                            if pathModel.searchPathType() == .questionList {
                                                pathModel.pushView(screen: QuestionListPathType.comment(post: post))
                                            } else if pathModel.searchPathType() == .bulletinBoard {
                                                pathModel.pushView(screen: BulletinBoardPathType.comment(post: post))
                                            }
                                        }
                                    }
                                }
                            } else {
                                // TODO: 질문 리스트로 가기
                            }
                        }
                        .onAppear {
                            if index == notificationUseCase.state.notificationList.count - 1
                                && notificationUseCase.state.hasNext {
                                print("Notification 페이지네이션")
                                notificationUseCase.fetchNotificationList()
                            }
                        }
                        
                        Separator()
                    }
                    
                    Text("알림은 7일간 보관됩니다.")
                        .font(Font.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub4)
                        .padding(.top, 16)
                }
                .padding(.horizontal, 24)
            }
            .refreshable {
                notificationUseCase.refreshNotificationList()
            }
            .alert("신고된 게시글", isPresented: $isReportedPostTappedAlert) {
                Button("확인", role: .none, action: {})
            } message: {
                Text("신고된 게시글은 열람할 수 없습니다.")
            }
        }
        .onAppear {
            bulletinBoardUseCase.effect(.fetchPost)
        }
    }
}

// MARK: - Preview

#Preview {
    NotificationListView()
}
