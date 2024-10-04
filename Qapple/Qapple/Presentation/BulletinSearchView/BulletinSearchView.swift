//
//  BulletinSearchView.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - BulletinSearchView

struct BulletinSearchView: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar()
                    
                    SearchBar(searchText: $bulletinBoardUseCase.searchText)
                        .padding(.horizontal, 16)
                    
                    if !bulletinBoardUseCase.state.searchPosts.isEmpty {
                        SearchListView(searchText: bulletinBoardUseCase.searchText)
                    } else {
                        NoResultView()
                    }
                }
                
                if bulletinBoardUseCase.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primary)
                }
            }
            .background(Background.first)
            .navigationBarBackButtonHidden()
        }
        .onChange(of: bulletinBoardUseCase.searchText) { _, newValue in
            bulletinBoardUseCase.state.searchTheshold = nil
            bulletinBoardUseCase.state.searchPosts.removeAll()
            print("아하!")
            if newValue.isEmpty {
                bulletinBoardUseCase.isLoading = false
            } else {
                bulletinBoardUseCase.isLoading = true
            }
        }
        .onDisappear {
            bulletinBoardUseCase.state.searchPosts.removeAll()
            bulletinBoardUseCase.searchText = ""
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    
    @EnvironmentObject private var pathModel: Router
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        CustomNavigationBar(
            leadingView: {
                CustomNavigationBackButton(buttonType: .arrow) {
                    dismiss()
                }
            },
            principalView: {
                Text("검색하기")
                    .font(Font.pretendard(.semiBold, size: 17))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {},
            backgroundColor: Background.first)
    }
}

// MARK: - SearchListView

private struct SearchListView: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @State private var selectedPost: Post?
    
    let searchText: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(bulletinBoardUseCase.state.searchPosts.enumerated()), id: \.offset) { index, post in
                    BulletinBoardCell(
                        post: post,
                        seeMoreAction: {
                            selectedPost = post
                        }
                    )
                    .onAppear {
                        if index == bulletinBoardUseCase.state.searchPosts.count - 1 && bulletinBoardUseCase.state.searchHasNext {
                            print("게시판 검색 페이지네이션")
                            bulletinBoardUseCase.effect(.searchPost(keyword: bulletinBoardUseCase.searchText))
                        }
                    }
                }
            }
        }
        .refreshable {
            bulletinBoardUseCase.effect(.refreshSearchPost(keyword: bulletinBoardUseCase.searchText))
        }
        .sheet(item: $selectedPost) { post in
            BulletinBoardSeeMoreSheetView(
                sheetType: post.isMine ? .mine : .others,
                post: post,
                isComment: false
            )
            .presentationDetents([.height(84)])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - NoResultView

private struct NoResultView: View {
    var body: some View {
        VStack {
            Text("검색 결과가 없어요")
                .font(Font.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub4)
                .padding(.top, 24)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    BulletinSearchView()
        .environmentObject(BulletinBoardUseCase())
}
