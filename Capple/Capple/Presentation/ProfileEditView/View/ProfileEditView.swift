//
//  ProfileEditView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct ProfileEditView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var viewModel: ProfileEditViewModel = .init()
    
    // 추후 중복 검사 변수 나오면 삭제 예정
    @State private var isEnableButton: Bool = false
    @State private var isClicked: Bool = false
    
    @State var defaultNickName: String
    private let nicknameLimit: Int = 15
    private var description: String = "* 캐플주스는 익명 닉네임을 권장하고 있어요"
    private var validationFailedDescription: String = "이미 사용 중인 닉네임이에요"
    
    init(nickName: String) {
        defaultNickName = nickName
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: {
                    CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.paths.removeLast()
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
                            viewModel.requestEditProfile()
                            pathModel.paths.removeLast()
                        }
                    } label: {
                        Text("완료")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundStyle(isEnableButton ? BrandPink.text : TextLabel.sub4)
                    }
                    .disabled(!isEnableButton)
                },
                backgroundColor: Background.second)
            
            Button {
                // TODO: 이미지 변경
            } label: {
                Image(.capple)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding(EdgeInsets(top: 24, leading: 0, bottom: 32, trailing: 0))
            }
            .disabled(true)
            
            VStack(alignment: .leading ,spacing: 0) {
                Text("닉네임")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 10)
                
                Spacer().frame(height: 21)
                
                ZStack(alignment: .leading) {
                    if viewModel.nickName.isEmpty {
                        Text("닉네임을 입력해주세요.")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                    }
                    
                    HStack(spacing: 0) {
                        TextField("", text: $viewModel.nickName)
                            .foregroundStyle(TextLabel.main)
                            .font(Font.pretendard(.semiBold, size: 20))
                            .frame(height: 14)
                            .onChange(of: viewModel.nickName) { _, newNickname in
                                if newNickname.isEmpty {
                                    isEnableButton = false
                                } else {
                                    isEnableButton = true
                                }
                                if newNickname.count > nicknameLimit {
                                    viewModel.nickName = String(newNickname.prefix(nicknameLimit))
                                }
                            }
                        Text("\(viewModel.nickName.count)/\(nicknameLimit)")
                            .foregroundStyle(TextLabel.placeholder)
                            .font(Font.pretendard(.semiBold, size: 14))
                            .frame(height: 8)
                    }
                    .frame(height: 14)
                    
                }
                
                Spacer().frame(height: 16)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(viewModel.nickName.isEmpty ? GrayScale.wh : BrandPink.button)
                
                Spacer().frame(height: 18)
                
                
                Text(description)
                    .font(Font.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.sub1)
                    .frame(height: 10)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
        }
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.nickName = defaultNickName
        }
    }
}

#Preview {
    ProfileEditView(nickName: "튼튼한 민톨")
}
