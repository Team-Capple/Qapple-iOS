//
//  TabBar.swift
//  Qapple
//
//  Created by 김민준 on 8/15/24.
//

import SwiftUI

// MARK: - TabBar

struct TabBar: View {
    
    @Binding private(set) var tabType: TabType
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabType.allCases) { tab in
                TabCell(
                    tabType: tab,
                    isSelected: tabType == tab.self
                )
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    tabType = tab
                }
            }
        }
        .frame(height: 80)
        .background(Background.first)
    }
}

private struct TabCell: View {
    
    let tabType: TabType
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            Spacer()
            
            Image(systemName: tabType.icon)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundStyle(isSelected ? BrandPink.button : GrayScale.icon)
            
            Text(tabType.title)
                .pretendard(.medium, 12)
                .foregroundStyle(isSelected ? BrandPink.text : GrayScale.icon)
                .padding(.top, 6)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.Background.first
        VStack {
            Spacer()
            TabBar(tabType: .constant(.questionList))
        }
    }
}
