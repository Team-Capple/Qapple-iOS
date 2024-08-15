//
//  CustomToolBarItem.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - CustomToolBarItem

struct CustomToolbarItem: View {
    
    enum ButtonType: String {
        case plus = "plus"
        case search = "magnifyingglass"
    }
    
    let buttonType: ButtonType
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Image(systemName: buttonType.rawValue)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(BrandPink.button)
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 24) {
        CustomToolbarItem(
            buttonType: .search,
            tapAction: {
                print("검색")
            }
        )
        
        CustomToolbarItem(
            buttonType: .plus,
            tapAction: {
                print("추가")
            }
        )
    }
}
