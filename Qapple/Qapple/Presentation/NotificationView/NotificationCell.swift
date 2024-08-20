//
//  NotificationCell.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import SwiftUI

struct NotificationCell: View {
    let targetContent: String
    let targetType: NotificationUseCase.NotificationTargetType
    let actionType: NotificationUseCase.NotificationActionType
    let commentContent: String?
    let timeStamp: Date
    let likeCount: Int
    let seeMoreAction: () -> Void
    
    var body: some View {
        Button {
            seeMoreAction()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                TitleView(targetType: targetType, actionType: actionType, timeStamp: timeStamp, likeCount: likeCount)
                
                ContentView(targetContent: targetContent, commentContent: commentContent)
            }
            .padding(.horizontal)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - TitleView

private struct TitleView: View {
    let targetType: NotificationUseCase.NotificationTargetType
    let actionType: NotificationUseCase.NotificationActionType
    let timeStamp: Date
    let likeCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            if actionType == .question {
                Text(targetType.description + actionType.description)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            } else if actionType == .like {
                Text("\(likeCount)개의 \(actionType.description)")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            } else {
                Text("누군가 내 \(targetType.description)에 \(actionType.description)")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            }
            
            Text(timeStamp.timeAgo)
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

// MARK: - PressableButtonStyle

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? .white.opacity(0.05) : Background.first)
            .animation(.none, value: configuration.isPressed)
    }
}

#Preview {
    NotificationCell(
        targetContent: "'어떤 게시글인지가 들어갑니다.'",
        targetType: .board,
        actionType: .like,
        commentContent: nil,
        timeStamp: Date(),
        likeCount: 18
    ) {
        print("해당 답변")
    }
}
