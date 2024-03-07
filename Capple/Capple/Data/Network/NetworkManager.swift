//
//  NetworkManager.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

class NetworkManager: ObservableObject {
    
}

// MARK: - 질문 API
extension NetworkManager {
    
    /// 오늘의 메인 질문을 조회합니다.
    static func fetchMainQuestions() async throws -> QuestionResponse.MainQuestions {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .questions)
        guard let url = URL(string: urlString) else {
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

// MARK: - 태그(키워드) API
extension NetworkManager {
    
    /// 검색한 태그(키워드)를 조회합니다.
    static func fetchSearchTag(request: TagRequest.Search) async throws -> TagResponse.Search {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .tagSearch) + "keyword=\(request.keyword)"
        guard let url = URL(string: urlString) else {
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
        let decodeData = try decoder.decode(BaseResponse<TagResponse.Search>.self, from: data)
        return decodeData.result
    }
}

