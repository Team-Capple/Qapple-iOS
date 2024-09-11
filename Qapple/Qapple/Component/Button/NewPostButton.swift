//
//  NewPostButton.swift
//  Qapple
//
//  Created by 김민준 on 8/19/24.
//

import SwiftUI

// MARK: - NewPostButton

struct NewPostButton: View {
    
    let title: String
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            HStack {}
                .pretendard(.semiBold, 17)
                .foregroundStyle(.white)
                .padding(.horizontal, 140)
                .padding(.vertical, 11)
                .frame(width: 161, height: 47, alignment: .center)
                .background(.regularMaterial)
                .cornerRadius(32)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .inset(by: 0.17)
                        .stroke(.white.opacity(0.5), lineWidth: 0.33)
                    
                )
                .overlay(
                    Text(title)
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundStyle(.white)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    NewPostButton(title: "게시글 작성") {}
}
