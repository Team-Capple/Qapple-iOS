//
//  AppDelegate.swift
//  Qapple
//
//  Created by Simmons on 8/18/24.
//

import SwiftUI
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate{
    
    let gcmMessageIDKey = "gcm.message_id"
    
    // 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
      
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // Setting Up Notifications...
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // APNs에 기기 등록을 요청
        application.registerForRemoteNotifications()
        
        
        // Setting Up Cloud Messaging...
        // 메세징 델리겟
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        // print("✅ [Device Token Successed]\n\(deviceTokenString)\n")
        
        // Device Token 업데이트
        SignInInfo.shared.deviceToken = deviceTokenString
      
        // deviceToken을 Firebase 메세징에 전달해 APNs 토큰을 설정
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // print("❌ [Device Token Failed]\n" + error.localizedDescription + "\n")
    }
}

// Cloud Messaging...
extension AppDelegate: MessagingDelegate{
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

//        print("토큰을 받았다")
//        // Store this token to firebase and retrieve when to send message to someone...
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        
//        // Store token in Firestore For Sending Notifications From Server in Future...
//        
//        print(dataDict)
     
    }
}

// User Notifications...[AKA InApp Notification...]

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  
    // 푸시 메세지가 앱이 켜져있을 때 나올 때
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
      
    let userInfo = notification.request.content.userInfo

    
    // Do Something With MSG Data...
    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }
    
    
    print(userInfo)

    completionHandler([[.banner, .badge, .sound]])
  }

    // 푸시메세지를 받았을 때
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // Do Something With MSG Data...
    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }
    
    if let questionId = userInfo["questionId"] {
        let idString = questionId as! String
        PushNotificationManager.shared.questionId = Int(idString)
    }
      
    if let boardId = userInfo["boardId"] {
        let idString = boardId as! String
        PushNotificationManager.shared.boardId = Int(idString)
    }
      
    print(userInfo)

    completionHandler()
  }
    
    // 앱이 종료된 상태에서 push 알림을 눌렀을 때
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(#function)
        if let questionId = userInfo["questionId"] {
            let idString = questionId as! String
            PushNotificationManager.shared.questionId = Int(idString)
        }
        
        if let boardId = userInfo["boardId"] {
            let idString = boardId as! String
            PushNotificationManager.shared.boardId = Int(idString)
        }
        
        completionHandler(.newData)
    }
}
