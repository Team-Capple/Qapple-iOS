//
//  GAService.swift
//  Qapple
//
//  Created by 김민준 on 3/6/25.
//

import Foundation
import ComposableArchitecture
import Firebase

/// Google Analytics Service
enum GAService {
    
    enum Event {
        case likeBoard(board: BulletinBoard)
        
        var name: String {
            switch self {
            case .likeBoard: "like_Board"
            }
        }
    }
    
    /// 로그를 전송합니다.
    static func log(_ event: Event) {
        var parameters = [String: Any]()
        
        switch event {
        case let .likeBoard(board):
            parameters = makePrameters([
                "board_Id": board.id,
                "content": board.content
            ])
        }
        
        Analytics.setUserID(userRandomID)
        Analytics.logEvent(event.name, parameters: parameters)
    }
}

// MARK: - Helper

extension GAService {
    
    /// UUID를 이용한 랜덤 ID 생성
    /// - 기존 UUID의 가독성을 높이기 위해 16글자로 줄이기
    /// - 추후 백엔드 서버의 memberID를 사용하는 것이 가장 좋아보임
    @Shared(.appStorage(Constant.userRandomID)) private static var userRandomID: String = {
        let id = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16)
        return String(id)
    }()
    
    /// Parameter를 기본값과 함께 생성합니다.
    private static func makePrameters(_ parmas: [String: Any]) -> [String: Any] {
        var parameters = [String: Any]()
        parmas.forEach { parameters.updateValue($0.value, forKey: $0.key) }
        return parameters
    }
}
