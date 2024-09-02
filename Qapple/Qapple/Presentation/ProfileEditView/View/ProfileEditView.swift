//
//  ProfileEditView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct ProfileEditView: View {
    
    @EnvironmentObject var pathModel: Router
    @StateObject private var viewModel: ProfileEditViewModel = .init()
    
    @State var defaultNickName: String
    @State private var isEditFailed = false
    @State private var isNicknameCheckButtonTapped = false
    
    private let nicknameLimit = 15
    
    /// 중복 검사 전 설명 문자입니다.
    private var beforeDescription: String {
        if viewModel.isNicknameFieldAvailable {
            return "* 캐플은 익명 닉네임을 권장해요"
        } else {
            return "초성, 숫자, 특수문자는 사용할 수 없어요"
        }
    }
    
    /// 중복 검사 후 설명 문자입니다.
    private var afterDescription: String {
        if viewModel.isNicknameCanUse {
            return "사용 가능한 닉네임이에요"
        } else {
            return "이미 사용 중인 닉네임이에요"
        }
    }
    
    init(nickName: String) {
        defaultNickName = nickName
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                leadingView: {
                    CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.pop()
                    }
                },
                principalView: {
                    Text("프로필 수정")
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {
                    Button {
                        Task {
                            do {
                                try await viewModel.requestEditProfile()
                                pathModel.pop()
                            } catch {
                                isEditFailed.toggle()
                            }
                        }
                    } label: {
                        Text("완료")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundStyle(viewModel.isNicknameCanUse ? BrandPink.text : TextLabel.sub4)
                    }
                    .disabled(!viewModel.isNicknameCanUse)
                    .alert("회원 정보 수정에 실패했습니다", isPresented: $isEditFailed) {
                        Button("확인", role: .none, action: {})
                    } message: {
                        Text("다시 요청해주세요")
                    }
                },
                backgroundColor: Background.second)
            
            HStack {
                Spacer()
                
                Button {
                    // TODO: 이미지 변경
                } label: {
                    Image(.profileDummy)
                        .resizable()
                        .frame(width: 72, height: 72)
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 24, leading: 0, bottom: 32, trailing: 0))
                }
                .disabled(true)
                
                Spacer()
            }
            
            Spacer().frame(height: 32)
            
            VStack(alignment: .leading) {
                Text("닉네임")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 10)
                
                Spacer().frame(height: 21)
                
                ZStack(alignment: .leading) {
                    if viewModel.nickname.isEmpty {
                        Text("닉네임을 입력해주세요")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $viewModel.nickname)
                            .foregroundStyle(TextLabel.main)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                            .autocorrectionDisabled()
                            .onChange(of: viewModel.nickname) { _ , nickname in
                                
                                // 닉네임 중복 검사 값  및 사용 가능 초기화
                                isNicknameCheckButtonTapped = false
                                viewModel.isNicknameCanUse = false
                                
                                // 글자 수 제한 로직
                                if nickname.count > nicknameLimit {
                                    viewModel.nickname = String(nickname.prefix(nicknameLimit))
                                    return
                                }
                                
                                // 띄어쓰기 방지 로직
                                viewModel.nickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                // 특수문자 방지 로직
                                viewModel.koreaLangCheck(nickname)
                            }
                        
                        Text("\(viewModel.nickname.count)/\(nicknameLimit)")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 14))
                            .frame(height: 8)
                    }
                    .frame(height: 14)
                }
                
                Spacer().frame(height: 16)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(viewModel.isNicknameCanUse ? GrayScale.wh : (viewModel.nickname.isEmpty ? GrayScale.wh : BrandPink.button))
                
                Spacer().frame(height: 8)
                
                HStack {
                    Text(!isNicknameCheckButtonTapped ? beforeDescription : afterDescription)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(viewModel.isNicknameFieldAvailable ? TextLabel.sub1 : Context.warning)
                    
                    Spacer()
                    
                    if viewModel.nickname != defaultNickName {
                        Button {
                            Task {
                                await viewModel.requestNicknameCheck()
                                isNicknameCheckButtonTapped = true
                            }
                        } label: {
                            Text("중복 검사")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle((viewModel.nickname.isEmpty || !viewModel.isNicknameFieldAvailable) ? TextLabel.sub4 : TextLabel.main)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            (viewModel.nickname.isEmpty || !viewModel.isNicknameFieldAvailable) ? GrayScale.secondaryButton : BrandPink.button)
                        .cornerRadius(20, corners: .allCorners)
                        .disabled(viewModel.nickname.isEmpty ||
                                  !viewModel.isNicknameFieldAvailable)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.nickname = defaultNickName
        }
    }
}

#Preview {
    ProfileEditView(nickName: "튼튼한 민톨")
}
