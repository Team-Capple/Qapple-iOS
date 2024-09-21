//
//  CommentRequest.swift
//  Qapple
//
//  Created by 문인범 on 9/4/24.
//

import Foundation


class CommentRequest {
    
    // 댓글 생성 POST
    struct UploadComment: Codable {
        let comment: String
    }
    
    struct ReportComment: Codable {
        let boardCommentId: Int
        let boardCommentReportType: String
    }
}
