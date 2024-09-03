//
//  NetworkManager+Board.swift
//  Qapple
//
//  Created by Simmons on 9/3/24.
//

import Foundation

// MARK: - 게시글 관련 API
extension NetworkManager {
    
    /// 게시글을 조회합니다.
    static func fetchBoard() async throws -> BoardResponse.Boards {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .boards)
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
        let decodeData = try decoder.decode(BaseResponse<BoardResponse.Boards>.self, from: data)
        return decodeData.result
    }
    
    /// 게시글 검색 조회
    static func fetchBoardOfSearch(_ request: BoardRequest.BoardOfSearch) async throws -> BoardResponse.SearchBoards {
        
        let urlString = ApiEndpoints.basicURLString(path: .boardsSearch) + "?keyword=\(request.keyword)"
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
        let decodeData = try decoder.decode(BaseResponse<BoardResponse.SearchBoards>.self, from: data)
        return decodeData.result
    }
    
    /// 게시글 등록
    static func requestRegisterBoard(_ request: BoardRequest.RegisterBoard) async throws -> BoardResponse.Boards {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answers)
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<BoardResponse.Boards>.self, from: data)
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    /// 게시글 좋아요
    static func requestLikeBoard(_ request: BoardRequest.LikeBoard) async throws -> BoardResponse.Boards {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answers) + "/\(request.boardId)/heart"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<BoardResponse.Boards>.self, from: data)
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    /// 게시글 삭제
    static func requestDeleteBoard(_ request: BoardRequest.DeleteBoard) async throws -> BoardResponse.Boards {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answers) + "/\(request.boardId)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
        let decodeData = try decoder.decode(BaseResponse<BoardResponse.Boards>.self, from: data)
        return decodeData.result
    }
    
}
