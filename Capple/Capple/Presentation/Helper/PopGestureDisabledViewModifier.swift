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
                print("pop false")
                await PopGestureManager.shared.updateAllowPopGesture(false)
            }
            .onDisappear {
                Task {
                    print("pop true")
                    await PopGestureManager.shared.updateAllowPopGesture(true)
                }
            }
    }
}
