//
//  CommentCell.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentCell: View {
    let comment: CommentResponse.Comments.Comment
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let anchorWidth: CGFloat = 73
    
    @State private var hOffset: CGFloat = 0
    @State private var anchor: CGFloat = 0
    @State private var isCellToggled: Bool = false
    
    @ObservedObject var commentViewModel: CommentViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 73)
            
            content
                .frame(width: screenWidth)
            
            if comment.isLiked {
                deleteBtn
            } else {
                reportBtn
            }
            
        }
        .offset(x: hOffset)
        .animation(.easeInOut, value: hOffset)
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                hOffset = anchor + value.translation.width
                
                if anchor < 0 {
                    isCellToggled = hOffset < -screenWidth / 3 + screenWidth / 15
                } else {
                    isCellToggled = hOffset < -screenWidth / 15
                }
            }
            .onEnded { value in
                if isCellToggled {
                    anchor = -anchorWidth
                } else {
                    anchor = 0
                }
                hOffset = anchor
            }
    }
    
    private var content: some View {
        HStack(alignment: .top, spacing: 13) {
            // 사용자 이미지
            Image(.profileDummy)
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    // 사용자 이름
                    Text("아무개 2")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(.icon)
                    
                    // 댓글 timestamp
                    Text(comment.createdAt)
                        .font(.pretendard(.light, size: 12))
                        .foregroundStyle(.disable)
                }
                
                // 댓글 내용
                Text(comment.content)
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.main)
            }
            .padding(.vertical, 16)
            
            Spacer()
            
            
            VStack {
                // 댓글 좋아요 버튼
                Button {
                    // TODO: 댓글 좋아요 기능
                    Task.init {
                        await commentViewModel.act(.like(id: comment.id))
                        await commentViewModel.loadComments(boardId: 1)
                    }
                } label: {
                    Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundStyle(comment.isLiked ? .button : .sub4)
                }
                
                // 댓글 좋아요 갯수
                if comment.heartCount != 0 {
                    Text("\(comment.heartCount)")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.sub3)
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .background(Color.bk)
        .gesture(drag)
    }
    
    private var deleteBtn: some View {
        Button {
            // TODO: 삭제 기능 구현
            Task.init {
                await commentViewModel.act(.delete(id: 1))
            }
        } label: {
            ZStack {
                Color.delete
                
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.wh)
            }
        }
        .frame(width: 73)
    }
    
    private var reportBtn: some View {
        Button {
            // TODO: 신고 기능 구현
            Task.init {
                await commentViewModel.act(.report(id: 1))
            }
        } label: {
            ZStack {
                Color.report
                
                Image(systemName: "light.beacon.min")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.wh)
            }
        }
        .frame(width: 73)
    }
}

//#Preview {
//    VStack {
//        CommentCell(comment: Comment(anonymityIndex: 1, isMine: false, isLike: true, likeCount: 12, content: "123123", timestamp: Date()), commentUseCase: .init())
//        CommentCell(comment: Comment(anonymityIndex: 2, isMine: true, isLike: false, likeCount: 0, content: "테스트", timestamp: Date().addingTimeInterval(-60*60*24)), commentUseCase: .init())
//    }
//}
