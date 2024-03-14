//
//  SignUpPrivacyView.swift
//  Capple
//
//  Created by 김민준 on 3/13/24.
//

import SwiftUI

struct SignUpPrivacyView: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                principalView: { Text("개인정보 처리방침")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    Text(privacyText)
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.main)
                }
            }
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SignUpPrivacyView()
}
