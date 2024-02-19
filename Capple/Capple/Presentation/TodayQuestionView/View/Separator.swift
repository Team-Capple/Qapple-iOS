//
//  Separator.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(GrayScale.stroke)
    }
}

#Preview {
    Separator()
}
