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
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            Image(.appleIDLoginButton)
        }
        .overlay {
            SignInWithAppleButton(
                onRequest: { request in
                    Task {
                        await authViewModel.appleLogin(request: request)
                    }
                },
                onCompletion: { result in
                    Task {
                        await authViewModel.appleLoginCompletion(result: result)
                        pathModel.paths.append(.inputNickName)
                    }
                }
            )
//            .blendMode(.overlay)
        }
    }
}

#Preview {
    AppleLoginButton(authViewModel: AuthViewModel())
}
