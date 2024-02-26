//
//  CustomNavigationBackButton.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    enum ButtonType: String {
        case arrow = "CustomBackButtonIcon"
        case xmark = "Xmark"
    }
    
    let buttonType: ButtonType
    
    init(buttonType: ButtonType) {
        self.buttonType = buttonType
    }
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(buttonType.rawValue) // 아이콘 변경 가능
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            .foregroundStyle(TextLabel.main)
        }
        // .padding(.leading, 24)
    }
}

#Preview {
    CustomNavigationBackButton(buttonType: .arrow)
}
