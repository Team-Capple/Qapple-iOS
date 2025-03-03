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
                    dayLeft: dayLeft(from: currentEvent.period.1)
                )
            } else {
                if let nextEvent = AcademyEventFor4th.nextEvent {
                    Header(
                        event: nextEvent,
                        dayLeft: dayLeft(from: nextEvent.period.0),
                        isCurrentEvent: false
                    )
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(.second)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// 종료 날짜까지 얼마나 남았는지 반환합니다.
    private func dayLeft(from date: Date) -> Int {
        Calendar
            .current
            .dateComponents([.day], from: .now, to: date)
            .day! + 1
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let event: AcademyEventFor4th
    let dayLeft: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Header(event: event, dayLeft: dayLeft, isCurrentEvent: true)
            
            HStack {
                Text(monthDayDate(event.period.0))
                Spacer()
                Text(monthDayDate(event.period.1))
            }
            .padding(.top, 16)
            .foregroundStyle(.main).opacity(0.6)
            .pretendard(.regular, 14)
            
            ProgressBar(
                event: event,
                dayLeftUntilNextEvent: dayLeft
            )
            .padding(.top, 8)
        }
    }
    
    /// 전체 날짜 포맷 문자열을 분리 문자열과 함께 반환합니다.
    /// ex) 03.03 or 03/03
    private func monthDayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: date)
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
            
            Text("\(dayLeft)\(isCurrentEvent ? "일 남음" : "일 후 시작")")
                .foregroundStyle(.main).opacity(0.8)
                .pretendard(.semiBold, 17)
        }
    }
}

// MARK: - ProgressBar

private struct ProgressBar: View {

    let event: AcademyEventFor4th
    let dayLeftUntilNextEvent: Int

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
        let total = Calendar
            .current
            .dateComponents([.day], from: startDate, to: endDate)
            .day ?? 0
        return Double(total - dayLeftUntilNextEvent) / Double(total)
    }
}

// MARK: - Preview

#Preview {
    QPAcademyDayCounter()
}
