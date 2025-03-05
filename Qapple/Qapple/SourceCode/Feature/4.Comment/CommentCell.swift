//
//  CommentCell.swift
//  Qapple
//
//  Created by 문인범 on 1/21/25.
//

import SwiftUI

struct CommentCell: View {
    let comment: BoardComment
    let like: () -> Void
    let delete: () -> Void
    let report: () -> Void
    
    @State private var hOffset: CGFloat = 0
    @State private var reportedCommentVisible: Bool = false
    
    var body: some View {
        ZStack {
            if comment.isReport, !reportedCommentVisible {
                ReportCell(reportedCommentVisible: $reportedCommentVisible)
            } else {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 73)
                    
                    CommentContentView(
                        hOffset: $hOffset,
                        reportedCommentVisible: $reportedCommentVisible,
                        comment: comment,
                        like: like
                    )
                    
                    if comment.isMine {
                        CommentDeleteButton(delete: delete)
                    } else {
                        CommentReportButton(report: report)
                    }
                }
                .offset(x: hOffset)
            }
        }
    }
}


// MARK: - ReportCell
private struct ReportCell: View {
    @Binding var reportedCommentVisible: Bool
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Text("신고에 의해 숨김처리 된 댓글입니다.")
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(.sub4)
                .padding(.leading, 16)
            
            Spacer()
            
            Button {
                reportedCommentVisible.toggle()
            } label: {
                Text("댓글 보기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.text)
            }
            .padding(.trailing, 27)
        }
        .frame(width: screenWidth, height: 56.03)
        .opacity(0.5)
    }
}


// MARK: - ReportedCommentCell
private struct CommentContentView: View {
    @State private var anchor: CGFloat = 0
    @State private var isCellToggled: Bool = false
    
    @Binding var hOffset: CGFloat
    @Binding var reportedCommentVisible: Bool
    
    let comment: BoardComment
    let like: () -> Void
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let anchorWidth: CGFloat = 73
    
    let publisher = NotificationCenter.default.publisher(for: .updateCommentCellToggle)
    
    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            // 사용자 이미지
            Image(.profileDummy)
                .resizable()
                .scaledToFit()
                .frame(width: 28)
                .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    // 사용자 이름
                    if self.comment.anonymityId == -1 {
                        Text("작성자")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(.text)
                    } else {
                        Text("러너 \(self.comment.anonymityId)")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(.icon)
                    }
                    
                    Capsule()
                        .frame(width: 32, height: 17)
                        .foregroundStyle(.writerGeneration)
                        .overlay {
                            Text(comment.writerGeneration)
                                .font(.pretendard(.medium, size: 10.7))
                                .foregroundStyle(.white)
                        }
                    
                    // 댓글 timestamp
                    Text(comment.createdAt.timeAgo)
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
                    if !comment.isReport {
                        like()
                    } else {
                        reportedCommentVisible.toggle()
                    }
                } label: {
                    if !comment.isReport {
                        VStack {
                            Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                                .foregroundStyle(comment.isLiked ? .button : .sub4)
                            
                            // 댓글 좋아요 갯수
                            if comment.heartCount != 0 {
                                Text("\(comment.heartCount)")
                                    .font(.pretendard(.medium, size: 14))
                                    .foregroundStyle(.sub3)
                            }
                        }
                    } else {
                        Text("댓글 숨기기")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(.text)
                    }
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .background(Color.bk)
        .frame(width: screenWidth)
        .gesture(drag, isEnabled: !comment.isReport)
        .onReceive(publisher) { _ in
            hOffset = 0
            anchor = 0
            isCellToggled = false
        }
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 50)
            .onChanged { value in
                withAnimation(.easeInOut) {
                    let transWidth = value.translation.width
                    
                    hOffset = anchor + transWidth
                    
                    if anchor < 0 {
                        isCellToggled = hOffset < -screenWidth / 3 + screenWidth / 15
                    } else {
                        isCellToggled = hOffset < -screenWidth / 15
                    }
                }
            }
            .onEnded { value in
                withAnimation(.easeInOut) {
                    if isCellToggled {
                        anchor = -anchorWidth
                    } else {
                        anchor = 0
                    }
                    hOffset = anchor
                }
            }
    }
}

// MARK: - CommentDeleteButton

private struct CommentDeleteButton: View {
    
    let delete: () -> Void
    
    var body: some View {
        Button {
            delete()
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
}

// MARK: - CommentReportButton

private struct CommentReportButton: View {
    
    let report: () -> Void
    
    var body: some View {
        Button {
            report()
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


#Preview {
    let comment = BoardComment(
        id: 4,
        writeId: 5,
        writerGeneration: "3기",
        content: "테스트입니다",
        heartCount: 20,
        isLiked: true,
        isMine: false,
        isReport: false,
        createdAt: .now,
        anonymityId: 2
    )
    
    CommentCell(
        comment: comment,
        like: {},
        delete: {},
        report: {})
}
