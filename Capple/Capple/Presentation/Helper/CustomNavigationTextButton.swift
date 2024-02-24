//
//  CustomNavigationTextButton.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationTextButton: View {
    let text: String
    let color: Color
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text(text)
            .foregroundStyle(color)
        }
    }
}

#Preview {
    CustomNavigationTextButton(text: "String", color: TextLabel.main)
}
