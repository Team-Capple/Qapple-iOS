//
//  SignUpTermsAgreementView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/12/24.
//

import SwiftUI

struct SignUpTermsAgreementView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isChecked: Bool = false // 추후 중복 검사 변수 나오면 삭제 예정
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.paths.removeLast()
                }},
                principalView: { Text("약관 동의")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
                .frame(height: 32)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("캐플에 오신것을 환영합니다!")
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
                
                ActionButton("확인", isActive: $isChecked, action: {
                    pathModel.paths.append(.signUpCompleted)
                })
                .animation(.easeIn, value: isChecked)
            }
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .alert("회원가입 실패", isPresented: $authViewModel.isSignUpFailedAlertPresented) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("네트워크 또는 서버 문제로 회원가입에 실패했습니다. 다시 시도 또는 관리자에게 문의 해주세요.")
        }
    }
}

#Preview {
    SignUpTermsAgreementView()
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
