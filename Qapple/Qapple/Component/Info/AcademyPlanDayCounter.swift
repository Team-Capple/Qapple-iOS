//
//  AcademyPlanDayCounter.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - AcademyPlanDayCounter

struct AcademyPlanDayCounter: View {
    
    let currentEvent: String
    let progress: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                CurrentEventTitle(currentEvent: currentEvent)
                
                Spacer()
                
                Image(.calendar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 54, height: 54)
            }
            
            ProgressBar(progress: progress)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Background.second)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - CurrentEventTitle

private struct CurrentEventTitle: View {
    
    let currentEvent: String
    let dayLeftUntilNextEvent = 23
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(currentEvent)
                    .foregroundStyle(BrandPink.text)
                    .pretendard(.bold, 23)
                
                Text("까지")
                    .foregroundStyle(TextLabel.main)
                    .pretendard(.semiBold, 15)
            }
            
            Text("D-\(dayLeftUntilNextEvent)")
                .foregroundStyle(TextLabel.main)
                .pretendard(.bold, 24)
        }
    }
}

// MARK: - ProgressBar

private struct ProgressBar: View {
    
    let progress: Double
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(TextLabel.placeholder)
                    .frame(width: proxy.size.width)
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(BrandPink.button)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: 16)
    }
}

// MARK: - Preview

#Preview {
    AcademyPlanDayCounter(
        currentEvent: "Prologue",
        progress: 0.37
    )
}
