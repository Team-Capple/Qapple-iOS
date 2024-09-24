//
//  NetworkManager+Token.swift
//  Qapple
//
//  Created by 김민준 on 9/23/24.
//

import Foundation

extension NetworkManager {
    
    /// 토큰을 재발급합니다.
    static func refreshToken() async throws -> TokenResponse.Refresh {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .tokenRefresh)
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(try SignInInfo.shared.token(.refresh))", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest: \(response.statusCode)")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<TokenResponse.Refresh>.self, from: data)
        return decodeData.result
    }
}
