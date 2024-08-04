//
//  CappleApp.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

@main
struct CappleApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                AppleLoginService.autoLogin()
            }
        }
    }
}
