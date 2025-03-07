//
//  AppDelegate+ScreenTime.swift
//  Qapple
//
//  Created by 김민준 on 3/7/25.
//

import UIKit

extension AppDelegate {
    
    /// 앱 접속 시간
    static var appEnterTime: Date?
    
    /// 앱 활성화 시간 기록
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppDelegate.appEnterTime = .now
    }
    
    /// 앱 종료 시간 기록
    func applicationWillResignActive(_ application: UIApplication) {
        if let appEnterTime = AppDelegate.appEnterTime {
            let screenTime = Date.now.timeIntervalSince(appEnterTime)
            GAService.log(.screenTime(duration: screenTime))
        }
    }
}
