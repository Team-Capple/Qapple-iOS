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

