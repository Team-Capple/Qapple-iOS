//
//  AppDelegate.swift
//  Qapple
//
//  Created by Simmons on 8/18/24.
//

import ComposableArchitecture
import SwiftUI
import Firebase
import FirebaseMessaging
import QappleRepository

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let mainFlowStore = QappleApp.mainFlowStore
    
    @Dependency(\.keychainService) var keychainService
    @Dependency(\.bulletinBoardRepository) var bulletinBoardRepository
    @Dependency(\.questionRepository) var questionRepository
}

// MARK: - UIApplicationDelegate

extension AppDelegate {
    
    /// 앱이 켜졌을 때
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        #if RELEASE
        RepositoryService.shared.configureServer(to: .production)
        #else
        RepositoryService.shared.configureServer(to: .test)
        #endif
        setupPushNotification(application)
        setupFirebase()
        return true
    }
    
    /// DeviceToken으로 원격 Notification에 등록 되었을 때
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        try? keychainService.createData(.deviceToken, deviceTokenString)
        
        // deviceToken을 Firebase 메세징에 전달해 APNs 토큰을 설정
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// 앱이 종료된 상태에서 PUSH 알림을 눌렀을 때
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        completionHandler(.newData)
    }
}

// MARK: - Helper

extension AppDelegate {
    
    /// Push Notification을 설정합니다.
    private func setupPushNotification(_ application: UIApplication) {
        UIApplication.shared.registerForRemoteNotifications()
        
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        
        // Push 알림 권한 요청
        requestPushNotificationAutorization()
        
        // APNs에 기기 등록을 요청
        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// FireBase를 설정합니다.
    private func setupFirebase() {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 메세징 델리겟
        Messaging.messaging().delegate = self
        
        // 디버깅 모드
        #if DEBUG
        var newArguments = ProcessInfo.processInfo.arguments
        newArguments.append("-FIRDebugEnabled")
        ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
        #endif
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

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {}
