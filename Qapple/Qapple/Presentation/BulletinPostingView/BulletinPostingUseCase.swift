//
//  BulletinPostingUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

final class BulletinPostingUseCase: ObservableObject {

    @Published var _state: State

    let textCountLimit = 150

    init() {
        self._state = State(
            content: ""
        )
    }
}

// MARK: - State

extension BulletinPostingUseCase {

    struct State {
        var content: String
    }
}

// MARK: - Effect

extension BulletinPostingUseCase {

    enum Effect {
        case uploadPost
    }

    func effect(_ effect: Effect) {
        switch effect {
        case .uploadPost:
            Task {
                try await NetworkManager.requestRegisterBoard(.init(content: _state.content, boardType: "FREEBOARD"))
            }
            print("포스팅을 업로드합니다.")
        }
    }
}
