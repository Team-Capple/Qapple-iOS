//
//  SignUpCompleteView.swift
//  Qapple
//
//  Created by 김민준 on 2/1/25.
//

import ComposableArchitecture
import SwiftUI

struct SignUpCompleteView: View {
    
    let store: StoreOf<SignUpCompleteFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            QPNavigationBar()
            
            Spacer()
            
            Text("캐플에 오신 것을 환영합니다 🍎 \n러너분들의 이야기를 들려주세요!")
                .foregroundStyle(.main)
                .pretendard(.bold, 24)
                .lineSpacing(12)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 2)
            
            QPActionButton("시작하기", isActive: true) {
                store.send(.startButtonTapped)
            }
            .padding(.top, 32)
            .padding(.horizontal, 120)
            .padding(.bottom, 48)
            
            Spacer()
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureEnabled(false)
    }
}

// MARK: - Preview

#Preview {
    SignUpCompleteView(store: Store(initialState: .init()) {
        SignUpCompleteFeature()
    })
}
