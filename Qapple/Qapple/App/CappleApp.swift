//
//  CappleApp.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

@main
struct CappleApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var authViewModel: AuthViewModel = .init()
    
    @State var tabType: TabType = .questionList
    
    var body: some Scene {
        WindowGroup {
//            TabBar(tabType: $tabType)
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
