//
//  CappleApp.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

@main
struct CappleApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var authViewModel: AuthViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            MainView(authViewModel: authViewModel)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                AppleLoginService.autoLogin { isSingIn in
                    DispatchQueue.main.async {
                        authViewModel.isSignIn = isSingIn
                    }
                }
            }
        }
    }
}
