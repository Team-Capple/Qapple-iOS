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
        if post.isMine {
            NormalBoardCell(
                post: post,
                seeMoreAction: seeMoreAction
            )
        } else {
            if post.isReported {
                ReportBoardCell(
                    post: post,
                    seeMoreAction: seeMoreAction
                )
            } else {
                NormalBoardCell(
                    post: post,
                    seeMoreAction: seeMoreAction
                )
            }
        }
    }
}
// MARK: - NormalBoardCell

private struct NormalBoardCell: View {
    
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
    
    private var nickname: String {
        if post.writerNickname == "알 수 없음" {
            return "(알 수 없음)"
        } else {
            return "익명의 러너"
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(nickname)
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
                    .disabled(post.isReported)
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
                    if !post.isLiked { HapticManager.shared.impact(style: .light) }
                    bulletinBoardUseCase.effect(.likePost(postId: post.boardId))
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
                pathModel.pushView(screen: BulletinBoardPathType.comment(post: post))
                bulletinBoardUseCase.isClickComment = true
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
            .disabled(bulletinBoardUseCase.isClickComment)
        }
    }
}

// MARK: - ReportBoardCell

private struct ReportBoardCell: View {

    @State private var isReportContentShow = false

    let post: Post
    let seeMoreAction: () -> Void

    var body: some View {
        Group {
            if !isReportContentShow {
                ReportHideView(isReportContentShow: $isReportContentShow)
            } else {
                ReportShowView(isReportContentShow: $isReportContentShow, post: post)
            }
        }
        .opacity(0.5)
    }
}

// MARK: - ReportShowView

private struct ReportShowView: View {
    
    @Binding private(set) var isReportContentShow: Bool
    
    let post: Post
    
    private var nickname: String {
        if post.writerNickname == "알 수 없음" {
            return "(알 수 없음)"
        } else {
            return "익명의 러너"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Image(.profileDummy)
                    .resizable()
                    .frame(width: 28, height: 28)

                Text(nickname)
                    .pretendard(.semiBold, 14)
                    .foregroundStyle(GrayScale.icon)
                    .padding(.leading, 8)

                Text("\(post.createAt.timeAgo)")
                    .pretendard(.regular, 14)
                    .foregroundStyle(TextLabel.sub4)
                    .padding(.leading, 6)

                Spacer()

                Button {
                    isReportContentShow.toggle()
                } label: {
                    Text("게시글 숨기기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(BrandPink.text)
                }
            }
            .padding(.horizontal, 16)

            ContentView(post: post)
                .padding(.horizontal, 16)
        }
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(Background.first)
    }
}

// MARK: - ReportHideView

private struct ReportHideView: View {
    
    @Binding private(set) var isReportContentShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("신고 되어 내용을 검토 중인 게시글이에요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.sub3)
                
                Spacer()
                
                Button {
                    isReportContentShow.toggle()
                } label: {
                    Text("게시글 보기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(BrandPink.text)
                }
            }
            .frame(height: 28)
            .padding(.horizontal, 16)

            HStack {
                Text("주의) 부적절한 콘텐츠가 포함될 수 있어요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.sub4)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 20)
        .padding(.bottom, 26)
        .background(Background.first)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        BulletinBoardCell(
            post: Post(
                boardId: 1,
                writerId: 2,
                writerNickname: "캐플짱",
                content: "캐플짱이라요~!",
                heartCount: 20,
                commentCount: 3,
                createAt: .now,
                isMine: true,
                isReported: false,
                isLiked: true
            )
        ) {}
        
        BulletinBoardCell(
            post: Post(
                boardId: 1,
                writerId: 2,
                writerNickname: "캐플짱",
                content: "캐플짱이라요~!",
                heartCount: 20,
                commentCount: 3,
                createAt: .now,
                isMine: false,
                isReported: true,
                isLiked: true
            )
        ) {}
    }
    .environmentObject(BulletinBoardUseCase())
}
