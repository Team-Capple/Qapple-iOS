//
//  KeywordChoiceChip.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI

struct KeywordChoiceChip: View {
    
    enum ButtonType {
        case label
        case addKeyword
    }
    
    var title: String
    var buttonType: ButtonType
    
    init(title: String, buttonType: ButtonType) {
        self.title = title
        self.buttonType = buttonType
    }
    
    var body: some View {
        
        Button {
            // TODO: - 키워드 추가 액션
        } label: {
            HStack(spacing: 4) {
                Text(buttonType == .label ? title: "키워드 추가")
                if buttonType == .addKeyword { Image(systemName: "plus") }
            }
            .font(.pretendard(.semiBold, size: 14))
            .foregroundStyle(.wh)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Color.Background.first
            .ignoresSafeArea()
        
        KeywordChoiceChip(title: "키워드", buttonType: .addKeyword)
    }
}
