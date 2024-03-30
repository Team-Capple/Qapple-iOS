//
//  HapticManager.swift
//  Capple
//
//  Created by 김민준 on 3/26/24.
//

import UIKit

/// 출처 : https://seons-dev.tistory.com/entry/SwiftUI-Haptic-Feedback-haptics-vibrations
final class HapticManager {
    static let shared = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
