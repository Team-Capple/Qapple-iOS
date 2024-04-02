//
//  AppleLoginButton.swift
//  Capple
//
//  Created by kyungsoolee on 3/9/24.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                Task {
                    authViewModel.isSignInLoading = true
                    await authViewModel.appleLogin(request: request)
                }
            },
            onCompletion: { result in
                Task {
                    await authViewModel.appleLoginCompletion(result: result)
                }
            }
        )
        .frame(height: 56)
        .signInWithAppleButtonStyle(.white)
    }
}

#Preview {
    ZStack {
        Color(Background.first)
            .ignoresSafeArea()
        
        AppleLoginButton()
    }
}
