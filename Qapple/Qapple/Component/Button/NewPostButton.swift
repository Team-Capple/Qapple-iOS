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
            Text(title)
                .pretendard(.semiBold, 17)
                .foregroundStyle(.white)
                .padding(.vertical, 12.5)
                .frame(width: 160)
                .background(.regularMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 32)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    NewPostButton(title: "게시글 작성") {}
}
