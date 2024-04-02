//
//  SignUpEULAView.swift
//  Qapple
//
//  Created by 김민준 on 4/2/24.
//

import SwiftUI

struct SignUpEULAView: View {
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow)   {
                    pathModel.paths.removeLast()
                }},
                principalView: { Text("최종 사용자 라이센스 계약(EULA)")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    Text("")
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
    SignUpEULAView()
}
