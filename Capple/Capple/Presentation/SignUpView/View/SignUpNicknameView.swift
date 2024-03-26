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
    
    @State private var isNicknameCheckButtonTapped = false
    
    private let nicknameLimit: Int = 15
    
    /// 중복 검사 전 설명 문자입니다.
    private var beforeDescription: String {
        if authViewModel.isNicknameFieldAvailable {
            return "* 캐플은 익명 닉네임을 권장해요"
        } else {
            return "초성, 숫자, 특수문자는 사용할 수 없어요"
        }
    }
    
    /// 중복 검사 후 설명 문자입니다.
    private var afterDescription: String {
        if authViewModel.isNicknameCanUse {
            return "사용 가능한 닉네임이에요"
        } else {
            return "이미 사용 중인 닉네임이에요"
        }
    }
    
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
                                
                                // 닉네임 중복 검사 값  및 사용 가능 초기화
                                isNicknameCheckButtonTapped = false
                                authViewModel.isNicknameCanUse = false
                                
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
                    .foregroundStyle(authViewModel.isNicknameCanUse ? GrayScale.wh : (authViewModel.nickname.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer().frame(height: 8)
                
                HStack {
                    Text(!isNicknameCheckButtonTapped ? beforeDescription : afterDescription)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(authViewModel.isNicknameFieldAvailable ? TextLabel.sub1 : Context.warning)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await authViewModel.requestNicknameCheck()
                            isNicknameCheckButtonTapped = true
                        }
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
                
                ActionButton("다음", isActive: $authViewModel.isNicknameCanUse, action: {
                    pathModel.paths.append(.agreement)
                })
                .padding(.bottom, 16)
                .animation(.easeIn, value: authViewModel.isNicknameCanUse)
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
