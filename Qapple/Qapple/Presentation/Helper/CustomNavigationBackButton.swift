//
//  CustomNavigationBackButton.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationBackButton: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    enum ButtonType: String {
        case arrow = "CustomBackButtonIcon"
        case xmark = "Xmark"
    }
    
    let buttonType: ButtonType
    let action: () -> Void
    
    init(buttonType: ButtonType, action: @escaping () -> Void) {
        self.buttonType = buttonType
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(buttonType.rawValue) // 아이콘 변경 가능
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            .foregroundStyle(TextLabel.main)
        }
    }
}

#Preview {
    CustomNavigationBackButton(buttonType: .arrow) {}
}
