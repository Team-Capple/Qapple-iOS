//
//  BulletinBoardView.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - BulletinBoardView

struct BulletinBoardView: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                BoardView()
                
                NewPostButton(
                    title: "게시글 작성",
                    tapAction: {
                        HapticManager.shared.notification(type: .success)
                        pathModel.pushView(screen: BulletinBoardPathType.bulletinPosting)
                    }
                )
                .position(
                    CGPoint(
                        x: proxy.size.width / 2,
                        y: proxy.size.height - 40
                    )
                )
                
                if bulletinBoardUseCase.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primary)
                }
            }
            .background(Background.first)
            .navigationDestination(for: BulletinBoardPathType.self) { path in
                pathModel.getNavigationDestination(view: path)
            }
        }
        .onAppear{
            bulletinBoardUseCase.isClickComment = false
            bulletinBoardUseCase.effect(.fetchPost)
        }
    }
}

// MARK: - BoardView

private struct BoardView: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
                .padding(.horizontal, 16)
            
            AcademyPlanDayCounter(
                currentEvent: bulletinBoardUseCase.state.currentEvent,
                startDate: bulletinBoardUseCase.state.startDate,
                endDate: bulletinBoardUseCase.state.endDate
            )
            .padding(.top, 20)
            .padding(.horizontal, 16)
            
            PostListView()
                .padding(.top, 20)
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        CustomTabBar()
    }
}

// MARK: - 커스텀 탭바
private struct CustomTabBar: View {
    
    @EnvironmentObject var pathModel: Router
    
    var body: some View {
        ZStack {
            Text("게시판")
                .pretendard(.medium, 16)
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                Spacer()
                
                Button {
                    pathModel.pushView(screen: BulletinBoardPathType.alert)
                } label: {
                    Image(.noticeIcon)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(GrayScale.icon)
                        .frame(width: 26 , height: 26)
                }
                
                Button {
                    pathModel.pushView(screen: BulletinBoardPathType.search)
                } label: {
                    Image(.search)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(GrayScale.icon)
                        .frame(width: 26 , height: 26)
                }
            }
            .padding(.trailing, 8)
        }
        .frame(height: 32)
    }
}

// MARK: - PostListView

private struct PostListView: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @EnvironmentObject private var pathModel: Router
    
    @State private var selectedPost: Post?
    @State private var isReportedPostTappedAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(bulletinBoardUseCase.state.posts.enumerated()), id: \.offset) { index, post in
                    BulletinBoardCell(
                        post: post,
                        seeMoreAction: {
                            selectedPost = post
                        }
                    )
                    .onAppear {
                        if index == bulletinBoardUseCase.state.posts.count - 1
                            && bulletinBoardUseCase.state.hasNext {
                            print("게시판 페이지네이션")
                            bulletinBoardUseCase.effect(.fetchPost)
                        }
                    }
                    .onTapGesture {
                        if !post.isReported {
                            pathModel.pushView(screen: BulletinBoardPathType.comment(post: post))
                            bulletinBoardUseCase.isClickComment = true
                        } else {
                            HapticManager.shared.notification(type: .warning)
                            isReportedPostTappedAlert.toggle()
                        }
                    }
                }
            }
        }
        .refreshable {
            bulletinBoardUseCase.refreshPostList()
        }
        .disabled(bulletinBoardUseCase.isLoading)
        .sheet(item: $selectedPost) { post in
            BulletinBoardSeeMoreSheetView(
                sheetType: post.isMine ? .mine : .others,
                post: post,
                isComment: false
            )
            .presentationDetents([.height(84)])
            .presentationDragIndicator(.visible)
        }
        .alert("신고된 게시글", isPresented: $isReportedPostTappedAlert) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("신고된 게시글은 열람할 수 없습니다.")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BulletinBoardView()
    }
    .environmentObject(Router(pathType: .bulletinBoard))
    .environmentObject(BulletinBoardUseCase())
}
