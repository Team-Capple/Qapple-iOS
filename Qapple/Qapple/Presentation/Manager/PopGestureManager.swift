//
//  PopGestureManager.swift
//  Capple
//
//  Created by 김민준 on 3/26/24.
//

import Foundation

final class PopGestureManager {
    static let shared = PopGestureManager()
    private init() {}
    
    /// Pop 제스처를 허용하는지 확인 변수
    private var isAllowPopGestureValue = true
    
    /// Pop 제스처 받아오기
    func isAllowPopGesture() -> Bool {
        return isAllowPopGestureValue
    }
    
    /// Pop 제스처를 허용하는 변수 업데이트
    @MainActor
    func updateAllowPopGesture(_ bool: Bool) async {
        isAllowPopGestureValue = bool
    }
}
