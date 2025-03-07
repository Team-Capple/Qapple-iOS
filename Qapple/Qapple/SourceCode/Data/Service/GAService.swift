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
        
        /// 앱 접속 시간
        case screenTime(duration: TimeInterval)
        
        /// 답변 작성
        case postAnswer(question: Question)
        
        /// 게시글 작성
        case postBoard(content: String)
        
        /// 게시글 리스트에서 좋아요
        case likeBoardFromList(board: BulletinBoard)
        
        /// 게시글 상세 페이지에서 좋아요
        case likeBoardFromDetail(board: BulletinBoard)
        
        /// 아카데미 일정 확인
        case checkAcademySchedule(event: AcademyEventFor4th)
        
        /// 게시글 댓글 작성
        case postBoardComment(board: BulletinBoard, comment: String)
        
        /// 게시글 댓글 좋아요
        case likeBoardComment(board: BulletinBoard, boardComment: BoardComment)
        
        /// Push 알림을 눌러 질문 탭으로 이동
        case navigateToQuestionTabFromPush(title: String, body: String, questionId: Int)
        
        /// Push 알림을 눌러 게시판 댓글로 이동
        case navigateToBoardCommentFromPush(title: String, body: String, board: BulletinBoard)
        
        var name: String {
            switch self {
            case .screenTime: "screen_time"
            case .postAnswer: "post_answer"
            case .postBoard: "post_board"
            case .likeBoardFromList: "like_board_from_list"
            case .likeBoardFromDetail: "like_board_from_detail"
            case .checkAcademySchedule: "check_academy_schedule"
            case .postBoardComment: "post_board_comment"
            case .likeBoardComment: "like_board_comment"
            case .navigateToQuestionTabFromPush: "navigate_to_question_tab_from_push_notification"
            case .navigateToBoardCommentFromPush: "navigate_to_board_comment_from_push_notification"
            }
        }
    }
    
    /// 로그를 전송합니다.
    static func log(_ event: Event) {
        var parameters = [String: Any]()
        
        switch event {
        case let .screenTime(duration):
            parameters = makePrameters([
                "duration": Int(duration),
            ])
            
        case let .postAnswer(question):
            parameters = makePrameters([
                "question_id": question.id,
                "question": question.content,
                "is_lived": question.isLived
            ])
            
        case let .postBoard(content):
            parameters = makePrameters([
                "content": content
            ])
            
        case let .likeBoardFromList(board):
            parameters = makePrameters([
                "board_id": board.id,
                "content": board.content,
                "heart_count": board.heartCount + 1
            ])
            
        case let .likeBoardFromDetail(board):
            parameters = makePrameters([
                "board_id": board.id,
                "content": board.content,
                "heart_count": board.heartCount + 1
            ])
            
        case let .checkAcademySchedule(event):
            parameters = makePrameters([
                "event_title": event.title
            ])
            
        case let .postBoardComment(board, comment):
            parameters = makePrameters([
                "board_id": board.id,
                "board_content": board.content,
                "comment_content": comment
            ])
            
        case let .likeBoardComment(board, comment):
            parameters = makePrameters([
                "board_id": board.id,
                "board_content": board.content,
                "board_heart_count": board.heartCount,
                "comment_content": comment.content,
                "comment_heart_count": comment.heartCount + 1
            ])
            
        case let .navigateToQuestionTabFromPush(title, body, questionId):
            parameters = makePrameters([
                "question_id": questionId,
                "title": title,
                "body": body
            ])
            
        case let .navigateToBoardCommentFromPush(title, body, board):
            parameters = makePrameters([
                "board_id": board.id,
                "content": board.content,
                "title": title,
                "body": body
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
