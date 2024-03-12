//
//  SignUpEmailView.swift
//  Capple
//
//  Created by 김민준 on 3/12/24.
//

import SwiftUI
import Combine

struct SignUpEmailView: View, KeyboardReadable {
    
    @EnvironmentObject var pathModel: PathModel
    
    @State private var emailText = ""
    @State private var isEnableButton = false
    @State private var isKeyboardVisible = false
    @State private var keyboardBottomPadding: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                principalView: { Text("이메일 인증")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first
            )
            
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
                    if emailText.isEmpty {
                        Text("이메일을 입력해주세요")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $emailText)
                            .foregroundStyle(isEnableButton ? TextLabel.main : BrandPink.text)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                        
                        Spacer()
                        
                        Text("@postech.ac.kr")
                            .foregroundStyle(emailText.isEmpty ? TextLabel.placeholder : BrandPink.text)
                            .font(Font.pretendard(.semiBold, size: 14))
                            .frame(height: 8)
                    }
                    .frame(height: 14)
                }
                
                Spacer()
                    .frame(height: 16)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(isEnableButton ? GrayScale.wh : (emailText.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer()
                    .frame(height: 18)
                
                HStack {
                    Text("* POVIS 계정 아이디를 입력해주세요")
                        .font(Font.pretendard(.semiBold, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .frame(height: 10)
                    
                    Spacer()
                    
                    Button {
                        pathModel.paths.append(.authCode)
                    } label: {
                        Text("메일 발송")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(TextLabel.main)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(BrandPink.button)
                    .cornerRadius(20, corners: .allCorners)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            if isKeyboardVisible {
                keyboardBottomPadding = 16
            } else {
                keyboardBottomPadding = 0
            }
            isKeyboardVisible = newIsKeyboardVisible
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignUpEmailView()
}
