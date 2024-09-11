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
    
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar()
                    
                    SearchBar(searchText: $searchText)
                        .padding(.horizontal, 16)
                    
                    SearchListView(searchText: searchText)
                }
                
                NewPostButton(
                    title: "게시글 작성",
                    tapAction: {
                        pathModel.pushView(screen: BulletinBoardPathType.bulletinPosting)
                    }
                )
                .position(
                    CGPoint(
                        x: proxy.size.width / 2,
                        y: proxy.size.height - 40
                    )
                )
            }
            .background(Background.first)
            .navigationBarBackButtonHidden()
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
                    .font(Font.pretendard(.semiBold, size: 15))
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
    
    private var searchList: [Post] {
        bulletinBoardUseCase._state.posts.filter {
            $0.content.contains(searchText)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(searchList) { post in
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
    BulletinSearchView()
        .environmentObject(BulletinBoardUseCase())
}
