//
//  ReportRequest.swift
//  Qapple
//
//  Created by 김민준 on 4/12/24.
//

import Foundation

class ReportRequest {
    
    // 신고하기 POST
    struct Report: Codable {
        let answerId: Int
        let reportType: String
    }
    
    // 게시글 신고하기 POST
    struct ReportBoard: Codable {
        let boardId: Int
        let boardReportType: String
    }
}
