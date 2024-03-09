//
//  ActionButton.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI

struct ActionButton: View {
    
    @Binding var isActive: Bool
    
    let title: String
    let action: () -> Void
    
    init(_ title: String, isActive: Binding<Bool>, action: @escaping () -> Void) {
        self.title = title
        self._isActive = isActive
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.pretendard(.semiBold, size: 18))
                .foregroundStyle(isActive ? TextLabel.main : TextLabel.disable)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .background(isActive ? BrandPink.button : GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .disabled(isActive ? false : true)
    }
}

#Preview {
    ZStack {
        Color.Background.first
            .ignoresSafeArea()
        
        ActionButton("버튼입니당", isActive: .constant(true), action: {})
    }
}
