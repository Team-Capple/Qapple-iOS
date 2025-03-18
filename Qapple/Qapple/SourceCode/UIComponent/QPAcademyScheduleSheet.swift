//
//  QPAcademyScheduleSheet.swift
//  Qapple
//
//  Created by 김민준 on 3/3/25.
//

import SwiftUI

struct QPAcademyScheduleSheet: View {
    var body: some View {
        ZStack {
            Color.second.ignoresSafeArea()
            
            Group {
                if let currentEvent = AcademyEventFor4th.currentEvent {
                    ContentView(
                        event: currentEvent,
                        dayLeft: currentEvent.period.1.dayLeft,
                        isCurrentEvent: true
                    )
                } else {
                    if let nextEvent = AcademyEventFor4th.nextEvent {
                        ContentView(
                            event: nextEvent,
                            dayLeft: nextEvent.period.0.dayLeft,
                            isCurrentEvent: false
                        )
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents(.init([.medium, .large]))
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let event: AcademyEventFor4th
    let dayLeft: Int
    let isCurrentEvent: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Header(
                event: event,
                dayLeft: dayLeft,
                isCurrentEvent: isCurrentEvent
            )
            .padding(.top, 32)
            .padding(.leading, 24)
            .padding(.trailing, 16)
            
            Text("아카데미 전체 일정")
                .foregroundStyle(.icon)
                .pretendard(.medium, 16)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            ScheudleList(selectedEvent: event)
                .padding(.top, 20)
            
            Spacer()
        }
    }
}

// MARK: - Header

private struct Header: View {
    
    let event: AcademyEventFor4th
    let dayLeft: Int
    let isCurrentEvent: Bool
    
    var body: some View {
        HStack {
            Text(event.title)
                .foregroundStyle(.text)
                .pretendard(.bold, 20)
                .layoutPriority(1)
            
            Text("\(dayLeft)\(isCurrentEvent ? "일 남음" : "일 후 시작")")
                .foregroundStyle(.main).opacity(0.8)
                .pretendard(.bold, 16)
                .padding(.leading, 0)
            
            Spacer()
            
            StartDateToEndDate()
        }
    }
    
    private func StartDateToEndDate() -> some View {
        HStack(spacing: 8) {
            Text(event.period.0.formatting(.md, separator: "/"))
                .foregroundStyle(.main).opacity(0.6)
                .pretendard(.bold, 15)
            
            Image(.halfArrow)
            
            Text(event.period.1.formatting(.md, separator: "/"))
                .foregroundStyle(.main).opacity(0.6)
                .pretendard(.bold, 15)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.stroke)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .layoutPriority(1)
    }
}

// MARK: - ScheduleList

private struct ScheudleList: View {
    
    let selectedEvent: AcademyEventFor4th
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(AcademyEventFor4th.allCases, id: \.title) { event in
                    VStack(spacing: 0) {
                        ScheduleCell(
                            event: event,
                            isSelected: selectedEvent == event
                        )
                        
                        if selectedEvent != event && event != .epilogue {
                            Image(.gradientSeparator)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: 0.5)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ScheduleCell

private struct ScheduleCell: View {
    
    let event: AcademyEventFor4th
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(event.title)
                .foregroundStyle(isSelected ? .icon : .sub2)
                .pretendard(isSelected ? .bold : .medium, 17)
            
            Spacer()
            
            StartDateToEndDate()
        }
        .frame(height: 58)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? .wh.opacity(0.09) : .clear)
                .padding(.horizontal, 10)
        )
    }
    
    private func StartDateToEndDate() -> some View {
        HStack(spacing: 0) {
            Text(event.period.0.formatting(.md, separator: "/"))
                .frame(width: 44)
            
            ZStack {
                Image(isSelected ? .longHalfArrowActive: .longHalfArrowInActive)
                
                Text("\(event.totalDays)일")
                    .foregroundStyle(isSelected ? .wh.opacity(0.8) : .icon.opacity(0.8))
                    .pretendard(isSelected ? .semiBold : .medium, 14)
                    .frame(width: 44, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(isSelected ? .clear : .stroke)
                            .fill(isSelected ? LinearGradient.pink : LinearGradient.clear)
                    )
            }
            .padding(.leading, 8)
            
            Text(event.period.1.formatting(.md, separator: "/"))
                .frame(width: 44)
                .padding(.leading, 8)
            
            Spacer()
        }
        .foregroundStyle(.wh)
        .pretendard(isSelected ? .semiBold : .medium, 16)
        .frame(width: 180)
    }
}

// MARK: - Preview

#Preview {
    QPAcademyScheduleSheet()
}
