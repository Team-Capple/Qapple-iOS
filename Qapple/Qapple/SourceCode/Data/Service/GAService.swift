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
        
        /// Push 알림을 눌러 질문 탭으로 이동
        case navigationToQuestionTabFromPush(title: String, body: String, questionId: Int)
        
        /// Push 알림을 눌러 게시판 댓글로 이동
        case navigateToBoardCommentFromPush(title: String, body: String, board: BulletinBoard)
        
        /// 게시글 작성
        case postBoard(content: String)
        
        /// 게시글 좋아요
        case likeBoard(board: BulletinBoard)
        
        var name: String {
            switch self {
            case .navigationToQuestionTabFromPush: "navigation_To_Question_Tab_From_Push"
            case .navigateToBoardCommentFromPush: "navigate_To_Board_Comment_From_Push"
            case .postBoard: "post_Board"
            case .likeBoard: "like_Board"
            }
        }
    }
    
    /// 로그를 전송합니다.
    static func log(_ event: Event) {
        var parameters = [String: Any]()
        
        switch event {
        case let .navigationToQuestionTabFromPush(title, body, questionId):
            parameters = makePrameters([
                "question_Id": questionId,
                "title": title,
                "body": body
            ])
            
        case let .navigateToBoardCommentFromPush(title, body, board):
            parameters = makePrameters([
                "board_Id": board.id,
                "content": board.content,
                "title": title,
                "body": body
            ])
            
        case let .postBoard(content):
            parameters = makePrameters([
                "content": content
            ])
            
        case let .likeBoard(board):
            parameters = makePrameters([
                "board_Id": board.id,
                "content": board.content,
                "heart_count": board.heartCount + 1
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
