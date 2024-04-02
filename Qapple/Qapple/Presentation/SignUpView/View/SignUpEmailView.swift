//
//  SignUpEmailView.swift
//  Capple
//
//  Created by 김민준 on 3/12/24.
//

import SwiftUI
import Combine

struct SignUpEmailView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isEnableButton = false
    @State private var isKeyboardVisible = false
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    authViewModel.resetAllInfo()
                    authViewModel.isSignIn = false
                    authViewModel.isSignUp = false
                    pathModel.paths.removeLast()
                }},
                principalView: { Text("회원가입")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first
            )
            
            Spacer()
                .frame(height: 32)
            
            VStack(alignment: .leading) {
                Text("이메일을 입력해주세요")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(TextLabel.main)
                
                Spacer()
                    .frame(height: 72)
                
                Text("이메일")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 10)
                
                Spacer()
                    .frame(height: 21)
                
                ZStack(alignment: .leading) {
                    if authViewModel.email.isEmpty {
                        Text("아이디를 입력해주세요")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $authViewModel.email)
                            .foregroundStyle(isEnableButton ? TextLabel.main : BrandPink.text)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                        
                        Spacer()
                        
                        Text(authViewModel.academyEmailAddress)
                            .foregroundStyle(authViewModel.email.isEmpty ? TextLabel.placeholder : BrandPink.text)
                            .font(Font.pretendard(.semiBold, size: 14))
                            .frame(height: 8)
                    }
                    .frame(height: 14)
                }
                
                Spacer()
                    .frame(height: 16)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(isEnableButton ? GrayScale.wh : (authViewModel.email.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer()
                    .frame(height: 18)
                
                HStack {
                    Text("* 아카데미 계정 아이디를 입력해주세요")
                        .font(Font.pretendard(.semiBold, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .frame(height: 10)
                    
                    Spacer()
                    
                    Button {
                        authViewModel.requestEmailCertification()
                        pathModel.paths.append(.authCode)
                    } label: {
                        Text("메일 발송")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(authViewModel.email.isEmpty ? TextLabel.sub4 : TextLabel.main)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(authViewModel.email.isEmpty ? GrayScale.secondaryButton : BrandPink.button)
                    .cornerRadius(20, corners: .allCorners)
                    .disabled(authViewModel.email.isEmpty)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignUpEmailView()
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
