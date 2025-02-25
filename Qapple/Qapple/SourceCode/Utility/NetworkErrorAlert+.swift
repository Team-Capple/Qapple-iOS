//
//  NetworkErrorAlert.swift
//  Qapple
//
//  Created by 김민준 on 2/8/25.
//

import ComposableArchitecture

extension AlertState {
    
    /// 네트워킹 실패 기본 Alert
    static func failedNetworking(with error: Error) -> Self {
        Self {
            TextState("네트워크 상태가 불안정해요")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("확인")
            }
        } message: {
            TextState("현재 상태가 지속될 시 관리자 문의를 부탁드려요 🥲\n\n\(error)")
        }
    }
}
