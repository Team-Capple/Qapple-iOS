//
//  SocialLoginView.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import SwiftUI
import AuthenticationServices

struct SocialLoginView: View {
    
    @Bindable var store: StoreOf<SocialLoginFeature>
    
    var body: some View {
        VStack(alignment : .leading, spacing: 0) {
            Text("우리끼리\n익명으로\n답변하기")
                .font(.pretendard(.extraBold, size: 32))
                .foregroundStyle(.main)
                .lineSpacing(12)
                .padding(.top, 120)
            
            Text("캐플")
                .font(.pretendard(.extraBold, size: 48))
                .foregroundStyle(.subText)
                .padding(.top, 24)
            
            Spacer()
            
            SignInWithAppleButton(
                onRequest: { request in
                    store.send(.appleLoginOnRequest(request))
                },
                onCompletion: { result in
                    store.send(.appleLoginOnCompletion(result))
                }
            )
            .frame(height: 56)
            .padding(.bottom, 40)
            .signInWithAppleButtonStyle(.whiteOutline)
        }
        .padding(.horizontal, 24)
        .background(LinearGradient.backgroundGradient)
        .ignoresSafeArea()
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - Preview

#Preview {
    SocialLoginView(store: Store(initialState: SocialLoginFeature.State()) {
        SocialLoginFeature()
    })
}
