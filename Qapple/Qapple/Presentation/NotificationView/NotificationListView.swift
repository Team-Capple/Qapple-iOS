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
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var notificationUseCase = NotificationUseCase()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                CustomNavigationBar(
                    leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.paths.removeLast()
                    }},
                    principalView: {
                        Text("알림")
                            .font(Font.pretendard(.semiBold, size: 17))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {},
                    backgroundColor: Background.first)
                
                ForEach(notificationUseCase._state.indices, id: \.self) { index in
                    let notification = notificationUseCase._state[index]
                    
                    NotificationCell(
                        userName: notification.userName,
                        actionDescription: notification.actionType.description,
                        timeStamp: notification.timeStamp
                    ) {
                        print("해당 답변") // TODO: 네비게이션 지정 or 버튼 제거
                    }
                    .padding(.horizontal)
                    
                    Separator()
                }
            }
        }
    }
}

#Preview {
    NotificationListView()
}
