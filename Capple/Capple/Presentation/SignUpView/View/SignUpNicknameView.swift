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
    
    @State private var nickname: String = ""
    @State private var isKeyboardVisible = false
    @State private var keyboardBottomPadding: CGFloat = 0
    
    // 추후 중복 검사 변수 나오면 삭제 예정
    @State private var isEnableButton: Bool = false
    
    private let nicknameLimit: Int = 15
    private var description: String = "* 캐플주스는 익명 닉네임을 권장하고 있어요"
    private var validationFailedDescription: String = "이미 사용 중인 닉네임이에요"
    
    var body: some View {
        
        VStack(spacing: 0) {
                CustomNavigationBar(
                    leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                    principalView: { Text("회원가입")
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main) },
                    trailingView: { },
                    backgroundColor: Background.first)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("사용할 닉네임을 입력해주세요")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 24))
                    .frame(height: 17)
                
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
                    if nickname.isEmpty {
                        Text("닉네임을 입력해주세요.")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $nickname)
                            .foregroundStyle(isEnableButton ? TextLabel.main: Context.warning)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                            .onChange(of: nickname) { newNickname in
                                // 20글자 제한
                                // print(newNickname)
                                if newNickname.isEmpty {
                                    isEnableButton = false
                                } else {
                                    isEnableButton = true
                                }
                                if newNickname.count > nicknameLimit {
                                    nickname = String(newNickname.prefix(nicknameLimit))
                                }
                            }
                        Text("\(nickname.count)/\(nicknameLimit)")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 14))
                            .frame(height: 8)
                    }
                    .frame(height: 14)
                    
                }
                
                Spacer().frame(height: 16)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(isEnableButton ? GrayScale.wh : (nickname.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer().frame(height: 18)
                
                
                Text("\(isEnableButton ? description : (nickname.isEmpty ? description : validationFailedDescription))")
                    .font(Font.pretendard(.semiBold, size: 14))
                    .foregroundStyle(isEnableButton ? TextLabel.sub1 : (nickname.isEmpty ? TextLabel.sub1 : Context.warning))
                    .frame(height: 10)
            }
            .padding(24)
            
            Spacer()
            
            Button {
                // 중복 체크가 성공했으면
                pathModel.paths.append(.agreement)
            } label: {
                if isEnableButton {
                    Image("NextDefaultButton")
                } else {
                    Image("NextDisableButton")
                }
            }
            .padding(.bottom, keyboardBottomPadding)
            .disabled(!isEnableButton)
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: isEnableButton)
        }
        .background(Background.first)
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            if isKeyboardVisible {
                keyboardBottomPadding = 16
            } else {
                keyboardBottomPadding = 0
            }
            // print("Is keyboard visible? ", newIsKeyboardVisible)
            isKeyboardVisible = newIsKeyboardVisible
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SignUpNicknameView()
}
