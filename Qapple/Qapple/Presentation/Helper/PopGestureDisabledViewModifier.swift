//
//  PopGestureDisabledViewModifier.swift
//  Capple
//
//  Created by 김민준 on 3/26/24.
//

import SwiftUI

struct PopGestureDisabledViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .task {
                await PopGestureManager.shared.updateAllowPopGesture(false)
            }
            .onDisappear {
                Task {
                    await PopGestureManager.shared.updateAllowPopGesture(true)
                }
            }
    }
}
