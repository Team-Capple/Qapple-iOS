//
//  AlertListRow.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct AlertListRow: View {
    
    let alert: Alert
    @State private var isConfirm = true
    
    var body: some View {
            Button {
                
            } label: {
                HStack {
                    Spacer()
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(alert.title)
                            .font(.pretendard(.semiBold, size: 15))
                            .foregroundStyle(TextLabel.main)
                        
                        Text(alert.contents)
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(TextLabel.sub2)
                            .multilineTextAlignment(.leading)
                        
                        Text(alert.question)
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(TextLabel.sub4)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                }
            }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(isConfirm ? Background.first: Background.second)
    }
}

#Preview {
    ZStack {
        Color(Background.first)
            .ignoresSafeArea()
        
        AlertListRow(
            alert: Alert(
                title: "오전 질문 마감 알림",
                contents: "오전 질문이 마감되었어요\n다른 러너들은 어떻게 답했는지 확인해보세요",
                question: "Q. 아카데미 러너 중 마음에 드는 유형이 있나요?"
            )
        )
    }
}
