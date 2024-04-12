//
//  ReportResponse.swift
//  Qapple
//
//  Created by 김민준 on 4/12/24.
//

import Foundation

struct ReportResponse {
    
    /// Report POST Response
    struct Report: Codable {
        let reportId: Int
    }
}
