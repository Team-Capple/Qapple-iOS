//
//  SeeAllButton.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct SeeAllButton: View {
    var body: some View {
        Button {
            print("전체보기")
        } label: {
            HStack(spacing: 1) {
                Text("전체보기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.main)
                    .frame(height: 10)
                
                Image(.arrowRight)
            }
        }
    }
}

#Preview {
    ZStack {
        Background.first.ignoresSafeArea()
        SeeAllButton()
    }
}
