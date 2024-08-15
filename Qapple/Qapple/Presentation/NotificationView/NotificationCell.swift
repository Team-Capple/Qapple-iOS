//
//  NotificationCell.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import SwiftUI

struct NotificationCell: View {
    let userName: String
    let actionDescription: String
    let timeStamp: Date
    let seeMoreAction: () -> Void
    
    var body: some View {
        Button {
            seeMoreAction()
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ContentView(userName: userName, actionDescription: actionDescription, timeStamp: timeStamp)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ContentView

private struct ContentView: View {
    let userName: String
    let actionDescription: String
    let timeStamp: Date
    
    var body: some View {
        HStack(spacing: 8) {
            Image("profileDummyImage")
                .resizable()
                .frame(width: 28, height: 28)
            
            Text("\(userName)님이 회원님의 답변에 \(actionDescription)")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(TextLabel.main)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        
        HStack {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            Text(timeStamp.fullDate) // TODO: 날짜 수정 필요
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(TextLabel.sub4)
        }
    }
}

#Preview {
    NotificationCell(
        userName: "아무개",
        actionDescription: "좋아요를 눌렀습니다",
        timeStamp: Date()
    ) {
        print("해당 답변")
    }
}
