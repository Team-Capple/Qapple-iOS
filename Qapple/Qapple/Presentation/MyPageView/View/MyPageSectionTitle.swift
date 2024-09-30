//
//  MyPageSectionTitle.swift
//  Qapple
//
//  Created by 김민준 on 9/28/24.
//

import SwiftUI

struct MyPageSectionTitle: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundStyle(TextLabel.main)
            .font(Font.pretendard(.bold, size: 18))
            .frame(height: 14)
    }
}

#Preview {
    MyPageSectionTitle(title: "질문/답변")
}
