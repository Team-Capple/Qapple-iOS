//
//  NotificationCell.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import SwiftUI

struct NotificationCell: View {
    let isQuestion: Bool
    let targetContent: String
    let userName: String
    let actionDescription: String
    let commentContent: String?
    let timeStamp: Date
    let seeMoreAction: () -> Void
    
    var body: some View {
        Button {
            seeMoreAction()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                TitleView(isQuestion: isQuestion, userName: userName, actionDescription: actionDescription, timeStamp: timeStamp)
                
                ContentView(targetContent: targetContent, commentContent: commentContent)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - TitleView

private struct TitleView: View {
    let isQuestion: Bool
    let userName: String
    let actionDescription: String
    let timeStamp: Date
    
    var body: some View {
        HStack(spacing: 8) {
            if !isQuestion {
                Image("profileDummyImage")
                    .resizable()
                    .frame(width: 28, height: 28)
                
                Text("\(userName)님이 \(actionDescription)")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            } else {
                Text(actionDescription)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            }
            
            Text(timeStamp.fullDate) // TODO: 날짜 수정 필요
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(TextLabel.sub4)
            
            Spacer()
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {
    let targetContent: String
    let commentContent: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let comment = commentContent {
                Text(comment)
                    .pretendard(.medium, 14)
                    .foregroundColor(.sub2) // TODO: 색 한번 검토 필요!
            }
            
            Text(targetContent)
                .pretendard(.medium, 14)
                .foregroundColor(.sub4)
        }
    }
}

#Preview {
    NotificationCell(
        isQuestion: true,
        targetContent: "'어떤 게시글인지가 들어갑니다.'",
        userName: "아무개",
        actionDescription: "댓글을 달았어요",
        commentContent: "내용이 들어갑니다.",
        timeStamp: Date()
    ) {
        print("해당 답변")
    }
}
