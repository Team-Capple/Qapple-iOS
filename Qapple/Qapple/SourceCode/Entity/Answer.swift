//
//  Answer.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import Foundation

struct Answer: Identifiable, Equatable {
    
    /// 답변 ID
    let id: Int
    
    /// 사용자 ID
    let writerId: Int
    
    /// 답변 내용
    let content: String
    
    /// 작성자 닉네임
    let authorNickname: String
    
    /// 작성자 기수
    let authorGeneration: String
    
    /// 답변 게시 날짜
    let publishedDate: Date
    
    /// 답변 신고 여부
    let isReported: Bool
    
    /// 현재 사용자가 작성한 답변인지 여부
    let isMine: Bool
    
    /// 내가 좋아요를 눌렀는지 여부
    var isLiked: Bool
    
    /// 탈퇴한 사용자의 답변인지 여부
    let isResignMember: Bool
    
    /// 답변에 대한 댓글 갯수
    let commentCount: Int
    
    /// 답변의 좋아요 갯수
    var heartCount: Int
    
    /// 초기화용 답변 엔티티
    static var initialState: Answer {
        Answer(
            id: 0,
            writerId: 0,
            content: "",
            authorNickname: "",
            authorGeneration: "",
            publishedDate: .now,
            isReported: false,
            isMine: true,
            isLiked: false,
            isResignMember: false,
            commentCount: 0,
            heartCount: 0
        )
    }
}
