//
//  CommentView.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentView: View {
    
    @StateObject private var commentViewModel: CommentViewModel = .init()
    @State private var text: String = ""
    
    let post: Post
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            BulletinBoardCell(post: self.post, seeMoreAction: {})
                .frame(width: UIScreen.main.bounds.width)
            
            ScrollView {
                VStack(spacing: 0) {
                    // 데이터 연결
                    ForEach(commentViewModel.comments) { comment in
                        seperator
                        
                        CommentCell(comment: comment, commentViewModel: commentViewModel)
                    }
                    
                    seperator
                    
                    Spacer(minLength: 50)
                }
            }
            .background(Color.bk)
            .refreshable {
                Task.init {
                    await commentViewModel.loadComments(boardId: 1)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .overlay(alignment: .bottom) {
            addComment
                .frame(width: screenWidth)
        }
        .navigationBarBackButtonHidden()
        .task {
            await commentViewModel.loadComments(boardId: 1)
        }
    }
    
    var seperator: some View {
        Rectangle()
            .foregroundStyle(Color.placeholder)
            .frame(height: 1)
    }
    
    var addComment: some View {
        HStack(alignment: .bottom) {
            TextField("댓글 추가", text: $text, axis: .vertical)
                .font(.pretendard(.regular, size: 17))
                .lineLimit(...3)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button {
                // TODO: 댓글 달기 기능 추가
                Task.init {
                    await commentViewModel.act(.upload(request: .init(boardId: 1, content: self.text)))
                    await commentViewModel.loadComments(boardId: 1)
                    self.text = ""
                }
            } label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.wh)
            }
            .padding(.trailing, 12)
            .padding(.bottom, 12)
        }
        .background {
            RoundedRectangle(cornerRadius: 11)
                .foregroundStyle(Color.placeholder)
        }
        
        .frame(minHeight: 50)
        .padding(.horizontal, 16)

    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

//#Preview {
//    CommentView(postId: UUID())
//}
