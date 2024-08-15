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
                    .frame(width: 64, height: 64)
            }
            
            ProgressBar(progress: progress)
        }
        .padding(20)
        .background(TextLabel.bk)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - CurrentEventTitle

private struct CurrentEventTitle: View {
    
    let currentEvent: String
    let dayLeftUntilNextEvent = 23
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Text(currentEvent)
                    .foregroundStyle(BrandPink.text)
                
                Text("까지")
                    .foregroundStyle(TextLabel.main)
            }
            
            Text("D-\(dayLeftUntilNextEvent)")
                .foregroundStyle(TextLabel.main)
        }
        .pretendard(.bold, 23)
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
        .frame(height: 20)
    }
}

// MARK: - Preview

#Preview {
    AcademyPlanDayCounter(
        currentEvent: "Prologue",
        progress: 0.37
    )
}
