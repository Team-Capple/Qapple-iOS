//
//  BulletinBoardCell.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - BulletinBoardCell

struct BulletinBoardCell: View {
    
    let post: Post
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(
                post: post,
                seeMoreAction: seeMoreAction
            )
            .padding(.horizontal, 16)
            
            ContentView(post: post)
                .padding(.horizontal, 16)
            
            Divider()
                .padding(.top, 16)
        }
        .padding(.top, 16)
        .background(Background.first)
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let post: Post
    let seeMoreAction: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text("러너 \(post.boardId + 1)")
                .pretendard(.semiBold, 14)
                .foregroundStyle(GrayScale.icon)
                .padding(.leading, 8)
            
            Text("\(post.createAt.timeAgo)")
                .pretendard(.regular, 14)
                .foregroundStyle(TextLabel.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(GrayScale.icon)
            }
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let post: Post
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(post.content)
                    .pretendard(.medium, 16)
                    .foregroundStyle(TextLabel.main)
                    .padding(.top, 2)
                
                RemoteView(post: post)
                    .padding(.top, 12)
            }
        }
    }
}

// MARK: - RemoteView

private struct RemoteView: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    let post: Post
    
    var body: some View {
        HStack {
            LikeButton(
                post: post,
                tapAction: {
                    bulletinBoardUseCase.effect(.likePost(postIndex: post.boardId))
                    bulletinBoardUseCase.effect(.fetchPost)
                }
            )
            
            CommentButton(post: post)
        }
    }
    
    struct LikeButton: View {
        let post: Post
        let tapAction: () -> Void
        
        var body: some View {
            Button {
                tapAction()
            } label: {
                HStack(spacing: 4) {
                    Image(post.isLiked ? .heartActive : .heart)
                    
                    Text("\(post.heartCount)")
                        .pretendard(.regular, 13)
                        .foregroundStyle(TextLabel.sub3)
                }
            }
        }
    }
    
    struct CommentButton: View {
        @EnvironmentObject private var pathModel: Router
        @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
        
        let post: Post
        
        var body: some View {
            Button {
                if !bulletinBoardUseCase.isClickComment {
                    pathModel.pushView(screen: BulletinBoardPathType.comment(post: post))
                    bulletinBoardUseCase.isClickComment = true
                    print(bulletinBoardUseCase.isClickComment)
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .frame(width: 15, height: 14)
                        .foregroundStyle(TextLabel.sub3)
                    
                    Text("\(post.commentCount)")
                        .pretendard(.regular, 13)
                        .foregroundStyle(TextLabel.sub3)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardCell(
        post: Post(
            boardId: 1,
            writerId: 2,
            content: "캐플짱이라요~!",
            heartCount: 20,
            commentCount: 3,
            createAt: .now,
            isMine: true,
            isReported: false,
            isLiked: true
        )
    ) {}
        .environmentObject(BulletinBoardUseCase())
}
