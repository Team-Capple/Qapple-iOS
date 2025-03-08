//
//  QappleApp.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import ComposableArchitecture
import AppTrackingTransparency
import SwiftUI

@main
struct QappleApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    static let mainFlowStore = Store(initialState: .init()) {
        MainFlowFeature()
    }
    
    private let signUpFlowStore = Store(initialState: .init()) {
        SignUpFlowFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if signUpFlowStore.isSignIn {
                    MainFlowView(store: QappleApp.mainFlowStore)
                } else {
                    SignUpFlowView(store: signUpFlowStore)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                requestAppTrackingTransparency()
                requestPushNotificationAutorization()
            }
        }
    }
}

// MARK: - Permission

extension QappleApp {
    
    /// 앱 추적 투명성 권한을 요청합니다.
    private func requestAppTrackingTransparency() {
        Task {
            await ATTrackingManager.requestTrackingAuthorization()
        }
    }
    
    /// Push Notification 권한을 요청합니다.
    private func requestPushNotificationAutorization() {
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: { _, _ in }
        )
    }
}
