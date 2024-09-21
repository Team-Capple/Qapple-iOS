//
//  NotificationRequest.swift
//  Qapple
//
//  Created by 김민준 on 9/21/24.
//

import Foundation

struct NotificationRequest {
    
    struct FetchNotificationRequest: Codable {
        let pageNumber: Int
        let pageSize: Int
    }
}
