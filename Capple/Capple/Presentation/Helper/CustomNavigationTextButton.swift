//
//  CustomNavigationTextButton.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationTextButton: View {
    
    enum ButtonType {
        case dismiss
        case next
    }
    
    
    let text: String
    let color: Color
    let buttonType: ButtonType
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button {
            if buttonType == .dismiss {
                self.presentationMode.wrappedValue.dismiss()
            } else if buttonType == .next {
                isPresented.toggle() // 추후 옵셔널 문제 생기면 여길 보시오
            }
        } label: {
            Text(text)
            .foregroundStyle(color)
        }
    }
}

#Preview {
    CustomNavigationTextButton(
        text: "String",
        color: TextLabel.main,
        buttonType: .dismiss,
        isPresented: .constant(false)
    )
}
