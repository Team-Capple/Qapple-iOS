//
//  CommentView.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentView: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @StateObject private var commentViewModel: CommentViewModel = .init()
    @State private var text: String = ""
    @State private var selectedPost: Post?

    @State var post: Post
    
    @State private var scrollIndex: Int?
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            BulletinBoardCell(
                post: self.post,
                seeMoreAction: {
                    selectedPost = post
                })
                .frame(width: UIScreen.main.bounds.width)
                .disabled(bulletinBoardUseCase.isLoading)
            
            commentList
            
            Spacer()
            
            addComment
                .frame(width: screenWidth)
                .padding(.bottom, 8)
        }
        .background(Color.bk)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
        .task {
            commentViewModel.postId = self.post.writerId
            await commentViewModel.loadComments(boardId: post.boardId)
            self.updatePost()
        }
        .sheet(item: $selectedPost) { post in
            BulletinBoardSeeMoreSheetView(
                sheetType: post.isMine ? .mine : .others,
                post: post,
                isComment: true
            )
            .presentationDetents([.height(84)])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: bulletinBoardUseCase.state.posts) { _, newPosts in
            if let updatedPost = newPosts.first(where: { $0.boardId == post.boardId }) {
                self.post = updatedPost
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateViewNotification)) { _ in
            Task {
                await self.refreshComments()
            }
        }
    }

    var commentList: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // 데이터 연결
                        ForEach(Array(commentViewModel.comments.enumerated()), id: \.offset) {
                            index,
                            comment in
                            seperator
                            
                            CommentCell(
                                comment: comment,
                                cellIndex: index,
                                commentViewModel: commentViewModel,
                                post: self.$post
                            )
                            .onAppear {
                                    if index == commentViewModel.comments.count - 1
                                        && commentViewModel.hasNext {
                                        print("페이지네이션")
                                        Task {
                                            await commentViewModel
                                                .loadComments(boardId: post.boardId)
                                        }
                                    }
                                }
                        }
                    }
                    .onChange(of: self.commentViewModel.scrollIndex) { _, index in
                        proxy.scrollTo(index)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .background(Color.bk)
                .refreshable {
                    if !self.commentViewModel.isLoading || !self.bulletinBoardUseCase.isLoading {
                        Task {
                            bulletinBoardUseCase.effect(.fetchSinglePost(postId: post.boardId))
                            await self.refreshComments()
                        }
                    }
                }
            }
            
            if self.commentViewModel.isLoading || self.bulletinBoardUseCase.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            if commentViewModel.comments.isEmpty && !self.commentViewModel.isLoading {
                VStack {
                    Text("아직 작성된 댓글이 없습니다")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.sub5)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                    
                    Spacer()
                }
            }
        }
    }
    
    // 댓글 작성 View
    var addComment: some View {
        HStack(alignment: .bottom) {
            TextField("댓글 추가", text: $text, axis: .vertical)
                .font(.pretendard(.regular, size: 17))
                .lineLimit(...3)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button {
                Task.init {
                    HapticManager.shared.notification(type: .success)
                    bulletinBoardUseCase.effect(.fetchSinglePost(postId: post.boardId))
                    await commentViewModel.act(.upload(id: post.boardId, request: .init(comment: self.text)))
                    await self.refreshComments()
                    self.commentViewModel.scrollIndex = commentViewModel.comments.count - 1
                    self.text = ""
                    self.hideKeyboard()
                }
            } label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            .tint(Color.wh)
            .padding(.trailing, 12)
            .padding(.bottom, 12)
            .disabled( self.text.isEmpty || self.commentViewModel.isLoading )
        }
        .background {
            RoundedRectangle(cornerRadius: 11)
                .foregroundStyle(Color.placeholder)
        }
        .frame(minHeight: 50)
        .padding(.horizontal, 16)
    }
    
    
    var seperator: some View {
        Rectangle()
            .foregroundStyle(Color.placeholder)
            .frame(height: 1)
    }
}


private struct HeaderView: View {
    
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        CustomNavigationBar(
            leadingView: { 
                CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.pop()
                }
            },
            principalView: {
                Text("댓글")
                    .font(.pretendard(.semiBold, size: 17))
            },
            trailingView: {
                
            },
            backgroundColor: Color.Background.first)
    }
}

// MARK: View 업데이트 관련 메소드
extension CommentView {
    
    private func updatePost() {
        self.post.commentCount = self.commentViewModel.comments.count
    }
    
    private func refreshComments() async {
        await commentViewModel.refreshComments(boardId: post.boardId)
        while commentViewModel.hasNext {
            await commentViewModel.loadComments(boardId: post.boardId)
        }
        self.updatePost()
    }
}
