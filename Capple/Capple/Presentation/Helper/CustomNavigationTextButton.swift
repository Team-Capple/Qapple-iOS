//
//  CustomNavigationTextButton.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationTextButton: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    /// 버튼 타입
    enum ButtonType {
        case dismiss // Pop
        case next(pathType: PathType) // Push
    }
    
    let title: String // 버튼 타이틀
    let color: Color // 버튼 컬러
    let buttonType: ButtonType // 버튼 타입
    let action: () -> Void
    
    var body: some View {
        Button {
            switch buttonType {
            case .dismiss:
                pathModel.paths.removeLast()
            case let .next(pathType):
                pathModel.paths.append(pathType)
            }
            action()
        } label: {
            Text(title)
            .foregroundStyle(color)
        }
    }
}

#Preview {
    CustomNavigationTextButton(
        title: "String",
        color: TextLabel.main,
        buttonType: .dismiss
    ) {}
}
