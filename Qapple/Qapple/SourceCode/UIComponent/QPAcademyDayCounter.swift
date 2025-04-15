//
//  QPAcademyDayCounter.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

struct QPAcademyDayCounter: View {
    
    var body: some View {
        Group {
            if let currentEvent = AcademyEventFor4th.currentEvent {
                ContentView(
                    event: currentEvent,
                    dayLeft: currentEvent.period.1.dayLeft
                )
            } else {
                if let nextEvent = AcademyEventFor4th.nextEvent {
                    Header(
                        event: nextEvent,
                        dayLeft: nextEvent.period.0.dayLeft,
                        isCurrentEvent: false
                    )
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(.second)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let event: AcademyEventFor4th
    let dayLeft: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Header(event: event, dayLeft: dayLeft, isCurrentEvent: true)
            
//            HStack {
//                Text(event.period.0.formatting(.mdKorean))
//                Spacer()
//                Text(event.period.1.formatting(.mdKorean))
//            }
//            .padding(.top, 16)
//            .padding(.horizontal, 2)
//            .foregroundStyle(.main).opacity(0.6)
//            .pretendard(.semiBold, 14)
            
//            ProgressBar(
//                event: event,
//                dayLeft: dayLeft
//            )
//            .padding(.top, 8)
        }
    }
}

// MARK: - Header

private struct Header: View {
    
    let event: AcademyEventFor4th
    let dayLeft: Int
    let isCurrentEvent: Bool
    
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
    }
    
    private var dayLeftText: String {
        if dayLeft == 0 {
            "마지막 날"
        } else {
            "\(dayLeft)\(isCurrentEvent ? "일 남음" : "일 후 시작")"
        }
    }
}

// MARK: - ProgressBar

private struct ProgressBar: View {

    let event: AcademyEventFor4th
    let dayLeft: Int

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(TextLabel.ph)
                    .frame(width: proxy.size.width)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.button)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: 16)
    }

    /// Progress 값을 반환합니다.
    private var progress: Double {
        let (startDate, endDate) = event.period
        let total = Calendar.utc
            .dateComponents([.day], from: startDate, to: endDate)
            .day ?? 0
        return Double(total - dayLeft) / Double(total)
    }
}

// MARK: - Preview

#Preview {
    QPAcademyDayCounter()
}
