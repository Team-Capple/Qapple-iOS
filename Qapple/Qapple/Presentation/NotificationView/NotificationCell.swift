//
//  NotificationCell.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import SwiftUI

struct NotificationCell: View {
    let notification: QappleNoti
    let seeMoreAction: () -> Void
    
    var body: some View {
        Button {
            seeMoreAction()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                TitleView(notification: notification)
                ContentView(notification: notification)
            }
            .padding(.horizontal, 24)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - TitleView

private struct TitleView: View {
    
    let notification: QappleNoti
    
    var body: some View {
        HStack(spacing: 8) {
            Text(notification.title)
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(TextLabel.main)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
            
            Text(notification.createAt.timeAgo)
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(TextLabel.sub4)
            
            Spacer()
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let notification: QappleNoti
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.content)
                .pretendard(.medium, 14)
                .foregroundColor(.sub2)
            
            if let subTitle = notification.subtitle {
                Text(subTitle)
                    .pretendard(.medium, 14)
                    .foregroundColor(.sub4)
            }
        }
    }
}

// MARK: - PressableButtonStyle

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 24)
            .background(configuration.isPressed ? .white.opacity(0.05) : Background.first)
            .animation(.none, value: configuration.isPressed)
    }
}

#Preview {
    NotificationCell(
        notification: .init(
            questionId: "",
            boardId: "0",
            boardCommentId: "0",
            title: "누군가가 내 게시글에 좋아요 누름!",
            subtitle: "와 진짜?",
            content: "대박박",
            createAt: .now,
            isReadStatus: false
        )
    ) {
        print("해당 답변")
    }
}
