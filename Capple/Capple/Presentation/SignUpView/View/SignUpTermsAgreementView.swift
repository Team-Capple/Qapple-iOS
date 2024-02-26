//
//  SignUpTermsAgreementView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/12/24.
//

import SwiftUI

struct SignUpTermsAgreementView: View {
    // 추후 중복 검사 변수 나오면 삭제 예정
    @State private var isChecked: Bool = false
    @State private var isCompleted: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                principalView: { Text("회원가입")
                    .font(Font.pretendard(.semiBold, size: 17))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
            
            HStack {
                Spacer()
                Text("약관 동의")
                    .foregroundStyle(GrayScale.wh)
                Button {
                    isChecked.toggle()
                } label: {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square.fill")
                        .foregroundStyle(GrayScale.wh)
                }
                Spacer()
            }
            
            Spacer()
            
            Button {
                isCompleted.toggle()
            } label: {
                if isChecked {
                    Image("NextDefaultButton")
                } else {
                    Image("NextDisableButton")
                }
            }
            .disabled(!isChecked)
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: isChecked)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isCompleted) {
            SignUpCompletedView()
        }
    }
}

#Preview {
    SignUpTermsAgreementView()
}
