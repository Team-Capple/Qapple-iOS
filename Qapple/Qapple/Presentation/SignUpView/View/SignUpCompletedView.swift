//
//  SignUpCompletedView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct SignUpCompletedView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leadingView: {},
                    principalView: {},
                    trailingView: {},
                    backgroundColor: Background.first)
                
                Spacer()
                    .frame(height: 32)
                
                HStack {
                    Text("캐플에 오신걸 환영합니다.\n당신의 이야기를 들려주세요!")
                        .foregroundStyle(TextLabel.main)
                        .font(Font.pretendard(.bold, size: 24))
                        .lineSpacing(6)
                    
                    Spacer()
                }
                
                Spacer()
                
                Image(.appLogo)
                    .resizable()
                    .frame(width: 280, height: 280)
                    .padding(.bottom, 48)
                
                Spacer()
                
                ActionButton("시작하기", isActive: .constant(true)) {
                    Task {
                        await authViewModel.requestSignUp()
                        pathModel.paths.removeAll()
                        authViewModel.isSignIn = true
                    }
                }
                .padding(.bottom, 16)
                .disabled(authViewModel.isLoading)
            }
            
            if authViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
        .padding(.horizontal, 24)
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .popGestureDisabled()
        .alert("회원가입 실패", isPresented: $authViewModel.isSignUpFailedAlertPresented) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("네트워크 또는 서버 문제로 회원가입에 실패했습니다. 다시 시도 또는 관리자에게 문의 해주세요.")
        }
    }
}

#Preview {
    SignUpCompletedView()
        .environmentObject(AuthViewModel())
}
