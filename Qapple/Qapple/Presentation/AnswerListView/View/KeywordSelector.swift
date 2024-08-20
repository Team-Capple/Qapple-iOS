//
//  KeywordSelector.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import SwiftUI

struct KeywordSelector: View {
    
    enum Status {
        case normal
        case selected
    }
    
    @State var state: Status = .normal
    var keywordText: String
    var keywordCount: Int
    let action: () -> Void
    
    var body: some View {
        Button {
            state = state == .normal ? .selected : .normal
            action()
        } label: {
            HStack {
                Text(keywordText)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundColor(.white)
                
                Text("\(keywordCount)")
                    .font(.pretendard(.regular, size: 10))
                    .foregroundStyle(state == .normal ? TextLabel.sub3 : TextLabel.main)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(state == .normal ? GrayScale.secondaryButton : BrandPink.button)
            .cornerRadius(20)
        }
    }
}

#Preview {
    KeywordSelector(keywordText: "키워드", keywordCount: 13, action: {})
}
