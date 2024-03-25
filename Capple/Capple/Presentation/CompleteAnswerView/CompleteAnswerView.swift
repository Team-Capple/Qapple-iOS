//
//  CompleteAnswerView.swift
//  Capple
//
//  Created by 김민준 on 3/25/24.
//

import SwiftUI

struct CompleteAnswerView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: {},
                principalView: {},
                trailingView: {},
                backgroundColor: Background.first)
            
            Spacer()
                .frame(height: 32)
            
            HStack {
                Text("답변 등록이 완료됐어요!\n이제 다른 답변을 확인해볼까요?")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 24))
                    .lineSpacing(6)
                
                Spacer()
            }
            
            Spacer()
            
            Image(.questionComplete)
                .resizable()
                .frame(width: 240, height: 240)
                .padding(.bottom, 48)
            
            Spacer()
            
            ActionButton("확인", isActive: .constant(true)) {
                
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CompleteAnswerView()
}
