//
//  NetworkManager+Answer.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

// MARK: - 답변 관련 API
extension NetworkManager {
    
    /// 내가 작성한 답변을 조회합니다.
    static func fetchAnswers(pageNumber: Int, pageSize: Int) async throws -> AnswerResponse.Answers {
        
        // URL 객체 생성
        var urlString = ApiEndpoints.basicURLString(path: .answers)
        urlString += "?pageNumber=\(pageNumber)"
        urlString += "&pageSize=\(pageSize)"
        
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
        let decodeData = try decoder.decode(BaseResponse<AnswerResponse.Answers>.self, from: data)
        return decodeData.result
    }
    
    /// 특정 질문에 대한 답변을 조회합니다.
    static func fetchAnswersOfQuestion(request: AnswerRequest.AnswersOfQuestion) async throws -> AnswerResponse.AnswersOfQuestion {
        
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion) + "/\(request.questionId)?"
        guard let url = URL(string: urlString) else {
            throw NetworkError.cannotCreateURL
        }
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if let threshold = request.threshold {
            urlComponent.queryItems = [
                .init(name: "threshold", value: String(threshold)),
                .init(name: "pageNumber", value: String(request.pageNumber)),
                .init(name: "pageSize", value: String(request.pageSize))
            ]
        } else {
            urlComponent.queryItems = [
                .init(name: "pageNumber", value: String(request.pageNumber)),
                .init(name: "pageSize", value: String(request.pageSize))
            ]
        }
        
        guard let url = urlComponent.url else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        print("답변 조회하기: \(url)\n")
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print(response.statusCode)
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<AnswerResponse.AnswersOfQuestion>.self, from: data)
        return decodeData.result
    }
    
    /// 답변을 등록합니다.
    static func requestRegisterAnswer(request: AnswerRequest.RegisterAnswer, questionID: Int) async throws -> AnswerResponse.RegisterAnswer {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion) + "/\(questionID)"
        guard let url = URL(string: urlString) else {
            print("URL 객체 생성 실패")
            throw NetworkError.cannotCreateURL
        }
        
        // Request 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<AnswerResponse.RegisterAnswer>.self, from: data)
            // print("AnswerResponse.RegisterAnswer: \(decodeData.result)")
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    /// 내가 작성한 답변을 조회합니다.
    static func requestDeleteAnswer(_ request: AnswerRequest.DeleteAnswer) async throws -> AnswerResponse.DeleteAnswer {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answers) + "/\(request.answerId)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        print(url)
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<AnswerResponse.DeleteAnswer>.self, from: data)
        return decodeData.result
    }
}
