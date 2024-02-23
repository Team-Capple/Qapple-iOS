//
//  TodayQuestionActionButton.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct TodayQuestionActionButton: View {
    
    enum Priority {
        case primary
        case secondary
    }
    
    private let deviceHeight = UIScreen.main.bounds.height
    var text: String
    var backgroundColor: Color
    var action: () -> Void
    
    init(_ text: String, priority: Priority, action: @escaping () -> Void) {
        self.text = text
        self.backgroundColor = priority == .primary
        ? BrandPink.button : GrayScale.secondaryButton
        self.action = action
    }
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Text(text)
                .font(.pretendard(.semiBold, size: 17))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .foregroundStyle(TextLabel.main)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(0)
    }
}

#Preview {
    TodayQuestionActionButton("이전 질문 보러가기", priority: .primary) {}
}
