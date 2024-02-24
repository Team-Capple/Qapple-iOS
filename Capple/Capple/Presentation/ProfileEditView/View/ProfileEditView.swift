//
//  ProfileEditView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct ProfileEditView: View {
    
    @State private var nickname: String = ""
    @State private var isKeyboardVisible = false
    @State private var keyboardBottomPadding: CGFloat = 0
    
    // 추후 중복 검사 변수 나오면 삭제 예정
    @State private var isEnableButton: Bool = false
    @State private var isClicked: Bool = false
    
    private let nicknameLimit: Int = 15
    private var description: String = "* 캐플주스는 익명 닉네임을 권장하고 있어요"
    private var validationFailedDescription: String = "이미 사용 중인 닉네임이에요"
    
    var body: some View {
        ZStack {
            Background.second.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Button {
                    
                } label: {
                    Image("Capple")
                        .resizable()
                        .frame(width: 72, height: 72)
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 24, leading: 0, bottom: 32, trailing: 0))
                }
                
                VStack(alignment: .leading ,spacing: 0) {
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
                                    print(newNickname)
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
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomNavigationBackButton()
            }
            ToolbarItem(placement: .principal) {
                Text("프로필")
                    .foregroundStyle(TextLabel.main)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ProfileEditView()) {
                    CustomNavigationTextButton(text: "완료", color: BrandPink.text)
                }
            }
        }
    }
}

#Preview {
    ProfileEditView()
}
