//
//  AnswerCell.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

// MARK: - BulletinBoardCell

struct AnswerCell: View {
    
    let answer: Answer
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(
                answer: answer,
                seeMoreAction: seeMoreAction
            )
            .padding(.horizontal, 16)
            
            ContentView(answer: answer)
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
    
    let answer: Answer
    let seeMoreAction: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text("러너 \(answer.anonymityId + 1)")
                .pretendard(.semiBold, 14)
                .foregroundStyle(GrayScale.icon)
                .padding(.leading, 8)
            
            Text("\(answer.writingDate.timeAgo)")
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
    
    let answer: Answer
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(answer.content)
                    .pretendard(.medium, 16)
                    .foregroundStyle(TextLabel.main)
                    .padding(.top, 2)
                
                RemoteView(answer: answer)
                    .padding(.top, 12)
            }
        }
    }
}

// MARK: - RemoteView

private struct RemoteView: View {
    
    let answer: Answer
    
    var body: some View {
        LikeButton(
            answer: answer,
            tapAction: {
                // TODO: 좋아요 탭
            }
        )
    }
    
    struct LikeButton: View {
        let answer: Answer
        let tapAction: () -> Void
        
        var body: some View {
            Button {
                tapAction()
            } label: {
                HStack(spacing: 4) {
                    Image(answer.isLike ? .heartActive : .heart)
                    
                    Text("\(answer.likeCount)")
                        .pretendard(.regular, 13)
                        .foregroundStyle(TextLabel.sub3)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AnswerCell(
        answer: Answer(
            id: 0,
            anonymityId: 0,
            content: "다들 매크로 팀원 조합 어떠신가요?",
            isLike: true,
            likeCount: 4,
            writingDate: .now,
            isReported: true
        )
    ) {}
        .environmentObject(BulletinBoardUseCase())
}
