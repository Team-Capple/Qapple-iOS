//
//  Font+Extension.swift
//  Capple
//
//  Created by 김민준 on 2/10/24.
//

import SwiftUI

extension Font {
    
    /// Pretendard 폰트명 열거형
    enum Pretendard: String {
        case extraBold = "Pretendard-ExtraBold"
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
    }
    
    /// 커스텀 Pretendard 폰트를 반환합니다.
    static func pretendard(_ type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.rawValue, size: size)
    }
}

struct PretendardModifier: ViewModifier {
    
    /// Pretendard 폰트명 열거형
    enum FontWeight: String {
        case extraBold = "Pretendard-ExtraBold"
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
    }
    
    var weight: FontWeight
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom(weight.rawValue, size: size))
    }
}

extension View {
    
    /// 프리텐다드 커스텀 폰트를 적용 후 반환합니다.
    func pretendard(_ weight: PretendardModifier.FontWeight, _ size: CGFloat) -> some View {
        modifier(PretendardModifier(weight: weight, size: size))
    }
}
