//
//  CappleApp.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

@main
struct CappleApp: App {
    
    init() {
        setNavigationTitleAttributes()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
    
    private func setNavigationTitleAttributes() {
        // Large Navigation Title
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        // Inline Navigation Title
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
