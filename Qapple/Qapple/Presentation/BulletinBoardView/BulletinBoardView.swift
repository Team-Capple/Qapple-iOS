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
            VStack(spacing: 0) {
                NavigationBar()
                    .padding(.horizontal, 16)
                
                AcademyPlanDayCounter(
                    currentEvent: bulletinBoardUseCase._state.currentEvent,
                    progress: bulletinBoardUseCase._state.progress
                )
                .padding(.top, 20)
                .padding(.horizontal, 22)
                
                PostListView()
                    .padding(.top, 20)
            }
            .background(Background.first)
            .refreshable {
                // TODO: 데이터 새로 불러오기
            }
            .navigationDestination(for: BulletinBoardPathType.self) { path in
                pathModel.getNavigationDestination(view: path)
            }
        }
        .environmentObject(bulletinBoardUseCase)
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        HStack(spacing: 24) {
            Text("자유게시판")
                .pretendard(.bold, 25)
                .foregroundStyle(.white)
            
            Spacer()
            
            CustomToolbarItem(
                buttonType: .search,
                tapAction: {
                    // TODO: 게시글 검색하기 View 이동
                    pathModel.pushView(
                        screen: BulletinBoardPathType.bulletinSearch
                    )
                }
            )
            
            CustomToolbarItem(
                buttonType: .plus,
                tapAction: {
                    // TODO: 게시글 작성하기 View 이동
                    pathModel.pushView(
                        screen: BulletinBoardPathType.bulletinPosting
                    )
                }
            )
        }
        .frame(height: 32)
    }
}

// MARK: - PostListView

private struct PostListView: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @State private var selectedPost: Post?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
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
