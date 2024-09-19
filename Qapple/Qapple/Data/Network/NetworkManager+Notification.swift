//
//  NetworkManager+Notification.swift
//  Qapple
//
//  Created by 김민준 on 9/18/24.
//

import Foundation

extension NetworkManager {
    
    static func fetchNotificationList(_ request: NotificationRequest) async throws -> NotificationResponse {
        
        // URL 객체 생성
        var urlString = ApiEndpoints.basicURLString(path: .notifications)
        urlString += "?pageNumber=\(request.pageNumber)"
        urlString += "&pageSize=\(request.pageSize)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<NotificationResponse>.self, from: data)
        return decodeData.result
    }
}
