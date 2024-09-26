//
//  NetworkManager+Notification.swift
//  Qapple
//
//  Created by 김민준 on 9/21/24.
//

import Foundation

// MARK: - Notification 관련 API
extension NetworkManager {
    
    /// Notification 리스트를 조회합니다.
    static func fetchNotificationList(_ request: NotificationRequest.FetchNotificationRequest) async throws -> NotificationResponse.FetchNotificationResponse {
        
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
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest: \(response.statusCode)")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<NotificationResponse.FetchNotificationResponse>.self, from: data)
            return decodeData.result
        } catch {
            print("Decode 에러")
            throw NetworkError.decodeFailed
        }
    }
}
