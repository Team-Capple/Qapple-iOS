//
//  NotificationListView.swift
//  Qapple
//
//  Created by 문인범 on 1/26/25.
//

import SwiftUI
import ComposableArchitecture


/**
 Notification 뷰(푸쉬 알림 뷰)
 */
struct NotificationListView: View {
    @Bindable var store: StoreOf<NotificationFeature>
    
    var body: some View {
        ZStack {
            Color(Background.first).ignoresSafeArea()
            
            NotificationContentView(store: store)
        }
        .navigationBarBackButtonHidden()
        .popGestureEnabled(true)
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .onAppear {
            store.send(.onAppear)
        }
    }
}


// MARK: - NotificationContentView
private struct NotificationContentView: View {
    let store: StoreOf<NotificationFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            QPNavigationBar(
                title: "알림",
                leadingView: {
                    QPNavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                }
            )
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(enumerated(store.notifications), id: \.offset) { index, notification in
                        NotificationCell(notification: notification) {
                            store.send(.notificationCellTapped(index))
                        }
                        .disabled(store.isLoading)
                        .onAppear {
                            store.send(.onPaginationCellAppear(index))
                        }
                        
                        QPDivider()
                    }
                    
                    Text("알림은 7일간 보관됩니다.")
                        .font(Font.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub4)
                        .padding(.top, 16)
                }
            }
            .refreshable {
                store.send(.onRefresh)
            }
        }
    }
}


#Preview {
    NotificationListView(store: Store(initialState: .init()) {
        NotificationFeature()
    })
}
