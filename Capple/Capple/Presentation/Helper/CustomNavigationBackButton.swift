//
//  CustomNavigationBackButton.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("CustomBackButtonIcon") // 아이콘 변경 가능
            .foregroundStyle(TextLabel.main)
        }
    }
}

#Preview {
    CustomNavigationBackButton()
}
