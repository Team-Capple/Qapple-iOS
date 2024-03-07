//
//  NetworkManager.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

class NetworkManager: ObservableObject {
    
    /// 오늘의 메인 질문을 조회합니다.
    static func fetchMainQuestions() async throws -> QuestionResponse.MainQuestions {
        
        // URL 객체 생성
        guard let url = ApiEndpoints.basicURLString(path: .questions) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        print(data)
        print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<QuestionResponse.MainQuestions>.self, from: data)
        return decodeData.result
    }
}
