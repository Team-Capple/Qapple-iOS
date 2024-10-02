//
//  BoardRequest.swift
//  Qapple
//
//  Created by Simmons on 9/3/24.
//

import Foundation

class BoardRequest {
    
    /// 페이지별 게시글 조회 요청 구조체
    struct pageOfBoard {
        let pageNumber: Int
        let pageSize: Int
    }
    
    /// 특정 단어에 대한 게시글 검색 요청 구조체
    struct BoardOfSearch {
        let keyword: String
        let pageNumber: Int
        let pageSize: Int
    }
    
    /// 게시글 생성 구조체
    struct RegisterBoard: Codable {
        let content: String
        let boardType: String
    }
    
    /// 게시글 삭제 구조체
    struct DeleteBoard: Codable {
        let boardId: Int
    }
    
    /// 게시글 좋아요 및 좋아요 취소 구조체
    struct LikeBoard: Codable {
        let boardId: Int
    }
    
    /// 단건 게시글 조회 요청 구조체
    struct SingleBoard: Codable {
        let boardId: Int
    }
}
