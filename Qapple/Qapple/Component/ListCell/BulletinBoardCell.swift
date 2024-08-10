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
            
            ContentView(post: post)
        }
        .padding(16)
        .background(Background.first)
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let post: Post
    let seeMoreAction: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text("아무개 \(post.anonymityIndex + 1)")
                .pretendard(.semiBold, 14)
                .foregroundStyle(GrayScale.icon)
            
            Spacer()
            
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
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
                
                // TODO: 댓글 작성일 포맷 변경
                Text("\(post.writingDate.fullDate)")
                    .pretendard(.regular, 14)
                    .foregroundStyle(TextLabel.sub4)
                    .padding(.top, 8)
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
                    bulletinBoardUseCase.effect(.likePost(postIndex: post.anonymityIndex))
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
                    Image(post.isLike ? .heartActive : .heart)
                    
                    Text("\(post.likeCount)")
                        .pretendard(.regular, 13)
                        .foregroundStyle(TextLabel.sub3)
                }
            }
        }
    }
    
    struct CommentButton: View {
        let post: Post
        
        var body: some View {
            Button {
                // TODO: 댓글 화면 present
            } label: {
                HStack(spacing: 4) {
                    Image(.comment)
                    
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
            anonymityIndex: 0,
            isMine: true,
            content: "다들 매크로 팀원 조합 어떠신가요?",
            isLike: true,
            likeCount: 4,
            commentCount: 1,
            writingDate: .now
        )
    ) {}
}
