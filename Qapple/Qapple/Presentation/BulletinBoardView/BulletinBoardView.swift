//
//  BulletinBoardView.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - BulletinBoardView

struct BulletinBoardView: View {
    
    @StateObject private var bulletinBoardUseCase = BulletinBoardUseCase()
    
    var body: some View {
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
        .environmentObject(bulletinBoardUseCase)
        .refreshable {
            // TODO: 데이터 새로 불러오기
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
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
                }
            )
            
            CustomToolbarItem(
                buttonType: .plus,
                tapAction: {
                    // TODO: 게시글 작성하기 View 이동
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
}
