//
//  SignUpNicknameView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/11/24.
//

import SwiftUI
import Combine

struct SignUpNicknameView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isNicknameDuplicateCheck = false
    
    private let nicknameLimit: Int = 15
    private var description: String = "* 캐플은 익명 닉네임을 권장해요"
    private var validationFailedDescription: String = "이미 사용 중인 닉네임이에요"
    
    var body: some View {
        
        VStack(alignment: .leading) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.paths.removeLast()
                } },
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
                    .font(Font.pretendard(.medium, size: 16))
                    .frame(height: 11)
                
                
                Spacer().frame(height: 44)
                
                Text("닉네임")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 10)
                
                Spacer().frame(height: 21)
                
                ZStack(alignment: .leading) {
                    if authViewModel.nickname.isEmpty {
                        Text("닉네임을 입력해주세요")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $authViewModel.nickname)
                            .foregroundStyle(TextLabel.main)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                            .autocorrectionDisabled()
                            .onChange(of: authViewModel.nickname) { _ , nickName in
                                
                                // 글자 수 제한 로직
                                if nickName.count > nicknameLimit {
                                    authViewModel.nickname = String(nickName.prefix(nicknameLimit))
                                }
                                
                                // 띄어쓰기 방지 로직
                                authViewModel.nickname = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                // 특수문자 방지 로직
                                authViewModel.koreaLangCheck(nickName)
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
                    .foregroundStyle(isNicknameDuplicateCheck ? GrayScale.wh : (authViewModel.nickname.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer().frame(height: 8)
                
                HStack {
                    Text(
                        authViewModel.isNicknameFieldAvailable ?
                        description : "초성, 숫자, 특수문자는 사용할 수 없어요"
                    )
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(authViewModel.isNicknameFieldAvailable ? TextLabel.sub1 : Context.warning)
                    
                    Spacer()
                    
                    Button {
                        isNicknameDuplicateCheck.toggle()
                    } label: {
                        Text("중복 검사")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle((authViewModel.nickname.isEmpty || !authViewModel.isNicknameFieldAvailable) ? TextLabel.sub4 : TextLabel.main)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        (authViewModel.nickname.isEmpty || !authViewModel.isNicknameFieldAvailable) ? GrayScale.secondaryButton : BrandPink.button)
                    .cornerRadius(20, corners: .allCorners)
                    .disabled(authViewModel.nickname.isEmpty ||
                              !authViewModel.isNicknameFieldAvailable)
                }
                
                Spacer()
                
                ActionButton("다음", isActive: $isNicknameDuplicateCheck, action: {
                    pathModel.paths.append(.agreement)
                })
                .padding(.bottom, 16)
                .animation(.easeIn, value: isNicknameDuplicateCheck)
            }
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SignUpNicknameView()
        .environmentObject(AuthViewModel())
}
