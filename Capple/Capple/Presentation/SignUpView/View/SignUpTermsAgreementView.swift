//
//  SignUpTermsAgreementView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/12/24.
//

import SwiftUI

struct SignUpTermsAgreementView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @State private var isChecked: Bool = false // 추후 중복 검사 변수 나오면 삭제 예정
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                principalView: { Text("약관 동의")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("사용할 닉네임을 입력해주세요")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 24))
                    .frame(height: 17)
                
                Spacer()
                    .frame(height: 22)
                
                Text("회원가입을 위해서는 약관 동의가 필요해요")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 14))
                    .frame(height: 11)
                
                Spacer()
                    .frame(height: 44)
                
                HStack {
                    Text("약관 동의")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(TextLabel.main)
                    
                    Spacer()
                    
                    Button {
                        isChecked.toggle()
                    } label: {
                        Image(isChecked ? .checkboxActive : .checkboxInActive)
                    }
                }
                
                Spacer()
                    .frame(height: 24)
                
                HStack {
                    Text("(필수)개인정보 처리방침")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(TextLabel.sub2)
                    
                    Spacer()
                    
                    Button {
                        pathModel.paths.append(.privacy)
                    } label: {
                        Image(.arrowRight)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            Button {
                pathModel.paths.append(.signUpCompleted)
            } label: {
                if isChecked {
                    Image("NextDefaultButton")
                } else {
                    Image("NextDisableButton")
                }
            }
            .disabled(!isChecked)
            .animation(.easeIn, value: isChecked)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SignUpTermsAgreementView()
}
