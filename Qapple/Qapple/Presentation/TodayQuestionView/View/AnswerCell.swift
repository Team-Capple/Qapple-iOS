//
//  AnswerCell.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct AnswerCell: View {
    
    let anonymity: String
    let content: String
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let writingDate: Date
    let isReported: Bool
    let seeMoreAction: () -> Void
    
    var body: some View {
        if isReported {
            ReportAnswerCell(
                anonymity: anonymity,
                content: content,
                isReported: isReported,
                seeMoreAction: seeMoreAction
            )
        } else {
            NormalAnswerCell(
                anonymity: anonymity,
                content: content,
                isLike: isLike,
                likeCount: likeCount,
                commentCount: commentCount,
                writingDate: writingDate,
                seeMoreAction: seeMoreAction
            )
        }
    }
}

// MARK: - NormalAnswerCell

private struct NormalAnswerCell: View {
    
    let anonymity: String
    let content: String
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let writingDate: Date
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(
                anonymity: anonymity,
                seeMoreAction: seeMoreAction
            )
            
            ContentView(
                content: content,
                isLike: isLike,
                likeCount: likeCount,
                commentCount: commentCount,
                writingDate: writingDate
            )
        }
        .padding(24)
    }
}

// MARK: - ReportAnswerCell

private struct ReportAnswerCell: View {
    
    @State private var isReportContentShow = false
    
    var anonymity: String
    var content: String
    let isReported: Bool
    let seeMoreAction: () -> Void
    
    var body: some View {
        if !isReportContentShow {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("신고 되어 내용을 검토 중인 답변이에요")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.sub3)
                    
                    HStack {
                        Button {
                            isReportContentShow.toggle()
                        } label: {
                            Text("답변 보기")
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(BrandPink.text)
                        }
                        
                        Text("주의) 부적절한 콘텐츠가 포함될 수 있어요")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(TextLabel.sub4)
                    }
                }
                
                Spacer()
            }
            .padding(24)
        } else {
            VStack {
                HStack {
                    Image("profileDummyImage")
                    .resizable()
                    .frame(width: 28, height: 28)
                    
                    Spacer()
                        .frame(width: 8)
                    
                    Text(anonymity)
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(TextLabel.sub2)
                        .frame(height: 10)
                    
                    Spacer()
                    
                    Button {
                        isReportContentShow.toggle()
                    } label: {
                        Text("답변 숨기기")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(BrandPink.text)
                    }
                }
                
                Spacer()
                    .frame(height: 8)
                
                VStack(alignment: .leading) {
                    
                    Text(content)
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.main)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                        .frame(height: 12)
                }
                .padding(.leading, 36)
            }
            .padding(24)
        }
    }
}
// MARK: - HeaderView

private struct HeaderView: View {
    let anonymity: String
    let seeMoreAction: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Image("profileDummyImage") // 기존 이미지 설정은 프사가 있었던 것 같은데 익명제로 동일 이미지를 사용할 것 같음
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(anonymity)
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(TextLabel.sub2)
                .frame(height: 10)
            
            Spacer()
            
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(TextLabel.sub2)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
// MARK: - ContentView

private struct ContentView: View {
    
    let content: String
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let writingDate: Date
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 0) { // spacing 0 의문?
                Text(content)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                
                RemoteView(
                    isLike: isLike,
                    likeCount: likeCount,
                    commentCount: commentCount
                )
                
                Text("\(writingDate.fullDate)")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(TextLabel.sub4)
                    .padding(.top, 8)
            }
        }
    }
}
// MARK: - RemoteView

private struct RemoteView: View {
    
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    
    var body: some View {
        HStack {
            LikeButton(
                isLike: isLike,
                likeCount: likeCount
            )
            
            CommentButton(commentCount: commentCount)
        }
    }
    
    struct LikeButton: View {
        let isLike: Bool
        let likeCount: Int
        
        var body: some View {
            Button {
                // TODO: 좋아요 탭
            } label: {
                HStack(spacing: 4) {
                    Image(isLike ? .heartActive : .heart)
                    
                    Text("\(likeCount)")
                        .font(.pretendard(.regular, size: 13))
                        .foregroundStyle(TextLabel.sub3)
                }
            }
        }
    }
    
    struct CommentButton: View {
        let commentCount: Int
        
        var body: some View {
            Button {
                // TODO: 댓글 화면 present
            } label: {
                HStack(spacing: 4) {
                    Image(.comment) // 이미지 변경!
                    
                    Text("\(commentCount)")
                        .font(.pretendard(.regular, size: 13))
                        .foregroundStyle(TextLabel.sub3)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(Background.first)
            .ignoresSafeArea()
        
        AnswerCell(
            anonymity: "아무개",
            content: "지금 누가 팀이 있고 없는지 궁금해요",
            isLike: true,
            likeCount: 32,
            commentCount: 32,
            writingDate: Date(),
            isReported: false,
            seeMoreAction: {}
        )
    }
}
