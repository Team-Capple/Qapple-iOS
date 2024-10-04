//
//  MyPageSectionCell.swift
//  Qapple
//
//  Created by 김민준 on 9/28/24.
//

import SwiftUI

struct MyPageSectionCell: View {
    
    let title: String
    let icon: ImageResource
    let isDistructive: Bool
    let tapAction: () -> Void
    
    init(
        title: String,
        icon: ImageResource,
        isDistructive: Bool = false,
        tapAction: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isDistructive = isDistructive
        self.tapAction = tapAction
    }
    
    private var forgroundStyle: Color {
        isDistructive ? TextLabel.disable : TextLabel.sub2
    }
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            HStack(spacing: 12) {
                Image(icon)
                
                Text(title)
                    .foregroundStyle(forgroundStyle)
                    .font(Font.pretendard(.medium, size: 16))
                    .frame(height: 12)
                    .underline(isDistructive)
                
                Spacer()
            }
            .padding(.vertical, 12)
        }
        
        Rectangle().frame(height: 1).foregroundStyle(GrayScale.stroke)
    }
}

#Preview {
    MyPageSectionCell(
        title: "좋아요 한 답변 확인",
        icon: .likeAnswerIcon,
        tapAction: {}
    )
}
