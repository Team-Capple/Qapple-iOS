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
    @StateObject private var bulletinBoardUseCase = BulletinBoardUseCase()
    
    var body: some View {
        NavigationStack(path: $pathModel.route) {
            GeometryReader { proxy in
                ZStack {
                    BoardView()
                    
                    NewPostButton(
                        title: "게시글 작성",
                        tapAction: {
                            pathModel.pushView(screen: BulletinBoardPathType.bulletinPosting)
                        }
                    )
                    .position(
                        CGPoint(
                            x: proxy.size.width / 2,
                            y: proxy.size.height - 72
                        )
                    )
                }
                .background(Background.first)
                .refreshable {
                    bulletinBoardUseCase.effect(.fetchPost)
                }
                .navigationDestination(for: BulletinBoardPathType.self) { path in
                    pathModel.getNavigationDestination(view: path)
                        .environmentObject(bulletinBoardUseCase)
                }
            }
            .onAppear{
                bulletinBoardUseCase.effect(.fetchPost)
            }
        }
        .environmentObject(bulletinBoardUseCase)
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
                currentEvent: bulletinBoardUseCase._state.currentEvent,
                startDate: bulletinBoardUseCase._state.startDate,
                endDate: bulletinBoardUseCase._state.endDate
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
            Text("자유게시판")
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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(bulletinBoardUseCase._state.posts) { post in
                    BulletinBoardCell(
                        post: post,
                        seeMoreAction: {
                            selectedPost = post
                        }
                    )
                }
            }
        }
        .sheet(item: $selectedPost) { post in
            BulletinBoardSeeMoreSheetView(
                sheetType: post.isMine ? .mine : .others,
                post: post
            )
            .presentationDetents([.height(84)])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BulletinBoardView()
    }
    .environmentObject(Router(pathType: .bulletinBoard))
}
