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
    @MainActor
    static func fetchMainQuestions() async throws -> QuestionResponse.Questions {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .questions)
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(data)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<QuestionResponse.Questions>.self, from: data)
            print("QuestionResponse.MainQuestions: \(decodeData.result)")
            return decodeData.result
        } catch {
            print("Decode 에러")
            throw NetworkError.decodeFailed
        }
    }
}

// MARK: - 답변 API
extension NetworkManager {
    
    /// 특정 질문에 대한 답변을 조회합니다.
    @MainActor
    static func fetchAnswersOfQuestion(request: AnswerRequest.AnswersOfQuestion) async throws -> AnswerResponse.AnswersOfQuestion {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion) + "/\(request.questionId)?" + "keyword=\(request.keyword ?? "")&size=\(request.size ?? 10)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(data)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<AnswerResponse.AnswersOfQuestion>.self, from: data)
        print("AnswerResponse.AnswersOfQuestion: \(decodeData.result)")
        return decodeData.result
    }
}

// MARK: - 태그(키워드) API
extension NetworkManager {
    
    /// 검색한 태그(키워드)를 조회합니다.
    @MainActor
    static func fetchSearchTag(request: TagRequest.Search) async throws -> TagResponse.Search {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .tagSearch) + "keyword=\(request.keyword)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(data)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<TagResponse.Search>.self, from: data)
        print("TagResponse.Search: \(decodeData.result)")
        return decodeData.result
    }
    
    /// 질문에 많이 사용된 태그(키워드)를 조회합니다.
    @MainActor
    static func fetchPopularTagsInQuestion(request: TagRequest.PopularTagsInQuestion) async throws -> TagResponse.PopularTagsInQuestion {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .popularTagsInQuestion) + "/\(request.questionId)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(data)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<TagResponse.PopularTagsInQuestion>.self, from: data)
        print("TagResponse.PopularTagsInQuestion: \(decodeData.result)")
        return decodeData.result
    }
}

