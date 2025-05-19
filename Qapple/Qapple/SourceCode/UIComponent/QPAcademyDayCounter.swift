//
//  QPAcademyDayCounter.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

struct QPAcademyDayCounter: View {
    
    let event: AcademyEventFor4th
    
    var body: some View {
        HStack(spacing: 8) {
            Image(.calendarIcon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 22, height: 22)
            
            Text(event.title)
                .foregroundStyle(.text)
                .pretendard(.bold, 20)
            
            Spacer()
            
            Text(dayLeftText)
                .foregroundStyle(.main).opacity(0.8)
                .pretendard(.semiBold, 17)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(.second)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var dayLeftText: String {
        if event.leftDays == 0 {
            "마지막 날"
        } else {
            "\(event.leftDays)일 남음"
        }
    }
}

// MARK: - Preview

#Preview {
    QPAcademyDayCounter(event: .currentEvent!)
}
