//
//  BulletinPostingUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

final class BulletinPostingUseCase: ObservableObject {
    
    @Published var _state: State
    @Published var isLoading: Bool = false
    
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
    
    @MainActor
    func effect(_ effect: Effect) async throws {
        switch effect {
        case .uploadPost:
            self.isLoading = true
            
            let _ = try await NetworkManager.requestRegisterBoard(.init(content: _state.content, boardType: "FREEBOARD"))
            self.isLoading = false
            print("포스팅을 업로드합니다.")
        }
    }
}
