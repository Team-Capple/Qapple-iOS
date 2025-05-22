//
//  Pagination+.swift
//  Qapple
//
//  Created by 김민준 on 1/22/25.
//

import SwiftUI

/// 페이지네이션을 위한 Modifier
struct ConfigurePagination: ViewModifier {
    let list: [Any]
    let currentIndex: Int
    let hasNext: Bool
    let pagination: () -> Void
    
    func body(content: Content) -> some View {
        content.onAppear {
            if currentIndex == list.endIndex - 10 && hasNext {
                pagination()
            }
        }
    }
}

extension View {
    func configurePagination(
        _ list: [Any],
        currentIndex: Int,
        hasNext: Bool,
        pagination: @escaping () -> Void
    ) -> some View {
        modifier(
            ConfigurePagination(
                list: list,
                currentIndex: currentIndex,
                hasNext: hasNext,
                pagination: pagination
            )
        )
    }
}
