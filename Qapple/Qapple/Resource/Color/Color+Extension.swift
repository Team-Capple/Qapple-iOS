//
//  Colors.swift
//  Capple
//
//  Created by 김민준 on 2/10/24.
//

import SwiftUI

typealias Background = Color.Background
typealias BrandPink = Color.BrandPink
typealias GrayScale = Color.GrayScale
typealias Context = Color.Context
typealias TextLabel = Color.TextLabel

extension Color {
    
    /// 배경 색상
    enum Background {
        static let first = Color(.first)
        static let second = Color(.second)
    }
    
    /// 메인 핑크 색상
    enum BrandPink {
        static let button = Color(.button)
        static let text = Color(.text)
        static let subText = Color(.subText)
        static let profile = Color(.profile)
        static let darkPink = Color(.darkPink)
    }
    
    /// 흑백 색상
    enum GrayScale {
        static let wh = Color(.wh)
        static let textFieldStroke = Color(.textFieldStroke)
        static let icon = Color(.icon)
        static let secondaryButton = Color(.secondaryButton)
        static let stroke = Color(.stroke)
    }
    
    /// 상황별 색상
    enum Context {
        static let warning = Color(.warning)
        static let onAir = Color(.onAir)
    }
    
    /// 라벨(텍스트) 색상
    enum TextLabel {
        static let main = Color(.main)
        static let sub1 = Color(.sub1)
        static let sub2 = Color(.sub2)
        static let sub3 = Color(.sub3)
        static let sub4 = Color(.sub4)
        static let disable = Color(.disable)
        static let placeholder = Color(.placeholder)
        static let bk = Color(.bk)
    }
}
