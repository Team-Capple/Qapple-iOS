//
//  SignUpAuthCodeView.swift
//  Capple
//
//  Created by 김민준 on 3/12/24.
//

import SwiftUI
import Combine

struct SignUpAuthCodeView: View, KeyboardReadable {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var authenticationCode = ""
    @State private var isEnableButton = false
    @State private var isKeyboardVisible = false
    @State private var keyboardBottomPadding: CGFloat = 0
    private let codeLimit = 4
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                principalView: { Text("인증 코드 입력")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first
            )
            
            VStack(alignment: .leading) {
                Text("인증 메일을 발송했어요")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(TextLabel.main)
                
                Spacer()
                    .frame(height: 22)
                
                Text("\(authViewModel.email)@postech.ac.kr 메일함을 확인해주세요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.sub3)
                    .lineLimit(2)
                
                Spacer()
                    .frame(height: 44)
                
                Text("인증코드")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 10)
                
                Spacer()
                    .frame(height: 21)
                
                ZStack(alignment: .leading) {
                    if authenticationCode.isEmpty {
                        Text("인증 코드를 입력해주세요")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $authenticationCode)
                            .foregroundStyle(isEnableButton ? TextLabel.main : BrandPink.text)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                            .keyboardType(.numberPad)
                            .onChange(of: authenticationCode) { newCode in
                                if newCode.count > codeLimit {
                                    authenticationCode = String(newCode.prefix(codeLimit))
                                }
                            }
                        
                        Spacer()
                        
                        Button {
                            // TODO: 인증 코드 확인 API
                            isEnableButton = true
                        } label: {
                            Text("인증 코드 확인")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(authenticationCode.count < 4 ? TextLabel.sub4 : TextLabel.main)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(authenticationCode.count < 4 ? GrayScale.secondaryButton : BrandPink.button)
                        .cornerRadius(20, corners: .allCorners)
                    }
                    .frame(height: 14)
                }
                
                Spacer()
                    .frame(height: 24)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(isEnableButton ? GrayScale.wh : (authenticationCode.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer()
                    .frame(height: 28)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("메일이 오지 않았나요? 스팸 메일함 혹은\n이메일 주소를 다시 한번 확인해주세요.")
                            .font(Font.pretendard(.semiBold, size: 14))
                            .foregroundStyle(TextLabel.sub3)
                            .lineLimit(2)
                            .lineSpacing(6)
                    }
                    
                    Spacer()
                    
                    Button {
                        // TODO: 메일 재발송 로직
                    } label: {
                        Text("메일 재발송")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(TextLabel.main)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(GrayScale.secondaryButton)
                    .cornerRadius(20, corners: .allCorners)
                }
                
                Spacer()
                
                Button {
                    pathModel.paths.append(.inputNickName)
                } label: {
                    if isEnableButton {
                        Image(.nextDefaultButton)
                    } else {
                        Image(.nextDisableButton)
                    }
                }
                .padding(.bottom, keyboardBottomPadding)
                .disabled(!isEnableButton)
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: isEnableButton)
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
    SignUpAuthCodeView()
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
