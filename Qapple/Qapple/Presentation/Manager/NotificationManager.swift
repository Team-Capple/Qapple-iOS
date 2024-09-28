//
//  Notification.swift
//  Capple
//
//  Created by 김민준 on 3/21/24.
//

import Foundation
import UserNotifications

struct NotificationAlert {
    var id: String
    var title: String
}

final class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    /// Notification 권한을 요청합니다.
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
            if didAllow {
                // print("Push: 권한 허용")
            } else {
                // print("Push: 권한 거부")
            }
        })
    }
    
    /// 권한에 따른 Notification을 스케줄링합니다.
    private func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                self.requestNotificationPermission()
            case .authorized, .provisional:
                self.scheduleMorningNotification()
                self.scheduleEveningNotification()
            default:
                break
            }
        }
    }
    
    /// 오전 질문 Notification을 스케줄링합니다.
    private func scheduleMorningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "오전 질문 준비 완료!"
        content.body = "지금 바로 답변해보세요."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "amNotification", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling amNotification: \(error.localizedDescription)")
            }
        }
    }
    
    /// 오후 질문 Notification을 스케줄링합니다.
    private func scheduleEveningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "오후 질문 준비 완료!"
        content.body = "지금 바로 답변해보세요."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 0
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "pmNotification", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error scheduling pmNotification: \(error.localizedDescription)")
            }
        }
    }
}
