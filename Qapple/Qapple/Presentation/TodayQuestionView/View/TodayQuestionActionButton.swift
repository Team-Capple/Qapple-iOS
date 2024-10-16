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
    var backgroundColor: Color
    var action: () -> Void
    
    init(_ text: String, backgroundColor: Color, action: @escaping () -> Void) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.pretendard(.semiBold, size: 17))
        }
        .frame(width: 168)
        .padding(.vertical, 14)
        .foregroundStyle(TextLabel.main)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    TodayQuestionActionButton(
        "이전 질문 보러가기",
        backgroundColor: BrandPink.button
    ) {}
}
