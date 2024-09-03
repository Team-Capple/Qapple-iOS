//
//  NetworkManager.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

class NetworkManager: ObservableObject {
    
}

// MARK: - 질문 관련 API

extension NetworkManager {
    
    /// 오늘의 메인 질문을 조회합니다.
    static func fetchMainQuestion() async throws -> QuestionResponse.MainQuestion {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .mainQuestion)
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
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<QuestionResponse.MainQuestion>.self, from: data)
            // print("QuestionResponse.MainQuestion: \(decodeData.result)")
            return decodeData.result
        } catch {
            print("Decode 에러")
            throw NetworkError.decodeFailed
        }
    }
}
