//
//  CommentCell.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentCell: View {
    let comment: CommentResponse.Comment
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let anchorWidth: CGFloat = 73
    
    @State private var hOffset: CGFloat = 0
    @State private var anchor: CGFloat = 0
    @State private var isCellToggled: Bool = false
    @State private var isDelete: Bool = false
    @State private var isDeleteComplete: Bool = false
    @State private var isReportedCommnet: Bool = false
    
    @EnvironmentObject private var pathModel: Router
    
    @ObservedObject var commentViewModel: CommentViewModel
    
    @Binding var post: Post
    
    var body: some View {
        ZStack {
            if !isReportedCommnet {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 73)
                    
                    content
                        .frame(width: screenWidth)
                    
                    if comment.isMine {
                        deleteBtn
                    } else {
                        reportBtn
                    }
                }
                .offset(x: hOffset)
                .animation(.easeInOut, value: hOffset)
            } else {
                HStack {
                    Text("신고에 의해 숨김처리 된 댓글입니다.")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(.sub4)
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button {
                        self.isReportedCommnet.toggle()
                    } label: {
                        Text("댓글 보기")
                            .font(.pretendard(.medium, size: 16.35))
                            .foregroundStyle(.text)
                    }
                    .padding(.trailing, 27)
                }
                .frame(width: screenWidth, height: 56.03)
            }
        }
        .alert("정말로 댓글을 삭제하시겠습니까?", isPresented: $isDelete) {
            Button("삭제", role: .destructive, action: {
                Task.init {
                    // TODO: Page Number 수정
                    await commentViewModel.act(.delete(id: comment.id))
                    self.isDeleteComplete.toggle()
                }
            })
            Button("취소", role: .cancel, action: {})
        }
        .alert("댓글이 삭제되었습니다!", isPresented: $isDeleteComplete) {
            Button("확인", role: .none) {
                Task.init {
                    await commentViewModel.loadComments(boardId: self.post.boardId)
                    self.post.commentCount = commentViewModel.comments.count
                }
            }
        }
        .onAppear {
            if comment.isReport {
                self.isReportedCommnet = true
            }
        }
        
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 50)
            .onChanged { value in
                let transWidth = value.translation.width

                hOffset = anchor + transWidth

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
                    if self.comment.isMine {
                        Text("작성자")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(.text)
                    } else {
                        Text("러너 \(self.comment.writerId)")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(.icon)
                    }
                    
                    // 댓글 timestamp
                    Text(comment.createdAt.ISO8601ToDate.timeAgo)
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
                    // TODO: Page Number 수정
                    Task.init {
                        HapticManager.shared.notification(type: .success)
                        await commentViewModel.act(.like(id: comment.id))
                        await commentViewModel.refreshComments(boardId: post.boardId)
                        self.post.commentCount = commentViewModel.comments.count
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
            self.isDelete.toggle()
            HapticManager.shared.notification(type: .error)
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
            pathModel.pushView(screen: BulletinBoardPathType.commentReport(comment: comment))
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

