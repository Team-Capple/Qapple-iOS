//
//  BulletinBoardUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation

final class BulletinBoardUseCase: ObservableObject {
    @Published var _state: State
    
    init() {
        self._state = State(
            currentEvent: "Prologue", // TODO: 실제 값 업데이트
            progress: 0.47, // TODO: 실제 값 업데이트
            posts: []
        )
    }
}

// MARK: - State

extension BulletinBoardUseCase {
    
    struct State {
        let currentEvent: String
        let progress: Double
        let posts: [Post]
    }
}
