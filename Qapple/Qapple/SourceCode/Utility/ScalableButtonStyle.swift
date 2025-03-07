//
//  ScalableButtonStyle.swift
//  Qapple
//
//  Created by 김민준 on 3/3/25.
//

import SwiftUI

/// 크기가 줄어드는 애니메이션 버튼 스타일
struct ScalableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(
                .spring(
                    response: 0.3,
                    dampingFraction: 0.5
                ),
                value: configuration.isPressed
            )
    }
}
