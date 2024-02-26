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
    var action: () -> Void
    
    init(_ title: String = "", buttonType: ButtonType, action: @escaping () -> Void) {
        self.title = title
        self.buttonType = buttonType
        self.action = action
    }
    
    var body: some View {
        
        Button {
            if buttonType == .addKeyword { action() }
        } label: {
            HStack(spacing: 4) {
                Text(buttonType == .label ? title: "키워드 추가")
                
                if buttonType == .addKeyword {
                    Image(systemName: "plus")
                } else {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .font(.pretendard(.semiBold, size: 14))
            .foregroundStyle(.wh)
        }
        .padding(.horizontal, 12)
        .frame(height: 32)
        .background(buttonType == .addKeyword ? GrayScale.secondaryButton : BrandPink.button)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Color.Background.first
            .ignoresSafeArea()
        
        VStack {
            KeywordChoiceChip("키워드", buttonType: .addKeyword, action: {})
            KeywordChoiceChip("키워드", buttonType: .label, action: {})
        }
    }
}
