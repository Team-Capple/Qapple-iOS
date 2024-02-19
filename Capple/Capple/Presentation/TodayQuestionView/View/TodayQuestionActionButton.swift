//
//  TodayQuestionActionButton.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct TodayQuestionActionButton: View {
    
    private let deviceHeight = UIScreen.main.bounds.height
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        
        Button {
            
        } label: {
            Text(text)
                .font(.pretendard(.semiBold, size: 17))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .foregroundStyle(TextLabel.main)
        .background(GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(0)
        // .offset(CGSize(width: 0.0, height: -deviceHeight / 2 + 334))
    }
}

#Preview {
    TodayQuestionActionButton("이전 질문 보러가기")
}
