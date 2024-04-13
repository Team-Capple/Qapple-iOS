//
//  SignUpServiceTermsView.swift
//  Qapple
//
//  Created by 김민준 on 4/2/24.
//

import SwiftUI

struct SignUpServiceTermsView: View {
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow)   {
                    pathModel.paths.removeLast()
                }},
                principalView: { Text("서비스 이용 약관")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    Text(serviceTermsText)
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.sub2)
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
    SignUpServiceTermsView()
}
