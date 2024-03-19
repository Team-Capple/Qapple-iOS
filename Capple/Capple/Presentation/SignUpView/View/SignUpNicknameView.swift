//
//  SignUpNicknameView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/11/24.
//

import SwiftUI
import Combine

struct SignUpNicknameView: View, KeyboardReadable {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isKeyboardVisible = false
    @State private var keyboardBottomPadding: CGFloat = 0
    
    // 추후 중복 검사 변수 나오면 삭제 예정
    @State private var isEnableButton: Bool = false
    
    private let nicknameLimit: Int = 15
    private var description: String = "* 캐플주스는 익명 닉네임을 권장하고 있어요"
    private var validationFailedDescription: String = "이미 사용 중인 닉네임이에요"
    
    var body: some View {
        
        VStack(alignment: .leading) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {} },
                principalView: { Text("회원가입")
                        .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first
            )
            
            Spacer()
                .frame(height: 32)
            
            VStack(alignment: .leading) {
                Text("사용할 닉네임을 입력해주세요")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 24))
                
                Spacer().frame(height: 22)
                
                Text("닉네임은 이후에도 변경이 가능해요")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 11)
                
                
                Spacer().frame(height: 44)
                
                Text("닉네임")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 10)
                
                Spacer().frame(height: 21)
                
                ZStack(alignment: .leading) {
                    // PlaceHolder(색상 변경때문에 사용)
                    if authViewModel.nickname.isEmpty {
                        Text("닉네임을 입력해주세요.")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $authViewModel.nickname)
                            .foregroundStyle(isEnableButton ? TextLabel.main: Context.warning)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                            .autocorrectionDisabled()
                            .onChange(of: authViewModel.nickname) { _, newNickname in
                                if newNickname.isEmpty {
                                    isEnableButton = false
                                } else {
                                    isEnableButton = true
                                }
                                if newNickname.count > nicknameLimit {
                                    authViewModel.nickname = String(newNickname.prefix(nicknameLimit))
                                }
                            }
                        
                        
                        Text("\(authViewModel.nickname.count)/\(nicknameLimit)")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 14))
                            .frame(height: 8)
                    }
                    .frame(height: 14)
                    
                }
                
                Spacer().frame(height: 16)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(isEnableButton ? GrayScale.wh : (authViewModel.nickname.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer().frame(height: 18)
                
                
                Text("\(isEnableButton ? description : (authViewModel.nickname.isEmpty ? description : validationFailedDescription))")
                    .font(Font.pretendard(.semiBold, size: 14))
                    .foregroundStyle(isEnableButton ? TextLabel.sub1 : (authViewModel.nickname.isEmpty ? TextLabel.sub1 : Context.warning))
                    .frame(height: 10)
                
                Spacer()
                
                ActionButton("확인", isActive: $isEnableButton, action: {
                    pathModel.paths.append(.agreement)
                })
                .padding(.bottom, keyboardBottomPadding)
                .animation(.easeIn, value: isEnableButton)
            }
            .padding(.horizontal, 24)
            
            Spacer()
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SignUpNicknameView()
        .environmentObject(AuthViewModel())
}
