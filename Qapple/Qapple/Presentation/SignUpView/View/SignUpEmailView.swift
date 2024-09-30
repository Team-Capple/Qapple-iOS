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
        ZStack {
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
                                .foregroundStyle(TextLabel.main)
                                .font(Font.pretendard(.semiBold, size: 20))
                                .frame(height: 14)
                            
                            Spacer()
                            
                            Text(authViewModel.academyEmailAddress)
                                .foregroundStyle(TextLabel.placeholder)
                                .font(Font.pretendard(.semiBold, size: 14))
                                .frame(height: 8)
                        }
                        .frame(height: 14)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(isEnableButton ? GrayScale.wh : (authViewModel.email.isEmpty ? TextLabel.placeholder : GrayScale.wh))
                    
                    Spacer()
                        .frame(height: 18)
                    
                    HStack(alignment: .top) {
                        Text("* 아카데미 계정 아이디를 입력해주세요")
                            .font(Font.pretendard(.semiBold, size: 14))
                            .foregroundStyle(TextLabel.sub3)
                        
                        Spacer()
                        
                        Button {
                            if authViewModel.email == authViewModel.testEmail {
                                pathModel.paths.removeAll()
                                authViewModel.isSignIn = true
                                return
                            }
                            
                            // 로딩 화면 시작
                            authViewModel.certifyMailLoading = true
                            
                            Task {
                                if await authViewModel.requestEmailCertification() {
                                    pathModel.paths.append(.authCode)
                                }
                                authViewModel.certifyMailLoading = false
                            }
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
                        .disabled(authViewModel.certifyMailLoading)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .background(Background.first)
            .navigationBarBackButtonHidden()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle()) // 로딩 바 스타일 설정
                .scaleEffect(2)
                .padding(.top, 60)
                .opacity(authViewModel.certifyMailLoading ? 1 : 0)
                .tint(.wh)
        }
        .alert("이미 가입된 이메일이에요", isPresented: $authViewModel.isExistEmailAlertPresented) {
            Button("확인", role: .none) {}
        } message: {
            Text("다른 이메일을 입력해주세요.")
        }
    }
}

#Preview {
    SignUpEmailView()
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
