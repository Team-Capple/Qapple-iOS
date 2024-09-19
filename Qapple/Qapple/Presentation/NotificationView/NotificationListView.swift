//
//  NotificationListView.swift
//  Qapple
//
//  Created by Simmons on 8/15/24.
//

import SwiftUI

struct NotificationListView: View {
    
    var body: some View {
        ZStack {
            Color(Background.first).ignoresSafeArea()
            
            VStack{
                NotificationContentView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - NotificationContentView

private struct NotificationContentView: View {
    
    @EnvironmentObject private var pathModel: Router
    @StateObject private var notificationUseCase = NotificationUseCase()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.pop()
                    }},
                    principalView: {
                        Text("알림")
                            .font(Font.pretendard(.semiBold, size: 17))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {},
                    backgroundColor: Background.first)
                
                ForEach(notificationUseCase.notificationList, id: \.createdAt) { notification in
//                    NotificationCell(
//                        targetContent: notification.targetContent,
//                        targetType: notification.targetType,
//                        actionType: notification.actionType,
//                        commentContent: notification.commentContent,
//                        timeStamp: notification.timeStamp,
//                        likeCount: notification.likeCount
//                    ){
//                        print("해당 답변") // TODO: 네비게이션 지정 or 버튼 제거
//                    }
                    
                    Separator()
                        .padding(.leading)
                }
            }
        }
    }
}

#Preview {
    NotificationListView()
}
