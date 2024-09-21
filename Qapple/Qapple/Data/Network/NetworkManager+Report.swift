//
//  NetworkManager+Report.swift
//  Qapple
//
//  Created by 김민준 on 4/12/24.
//

import Foundation

extension NetworkManager {
    
    /// 신고하기 요청을 합니다.
    static func requestReport(request: ReportRequest.Report) async throws -> ReportResponse.Report {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        // print("요청 데이터: \(requestData)")
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .report)
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
            let decodeData = try decoder.decode(BaseResponse<ReportResponse.Report>.self, from: data)
            // print("ReportResponse.Report: \(decodeData.result)")
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    /// 게시글 신고하기 요청을 합니다.
    static func requestReportBoard(request: ReportRequest.ReportBoard) async throws -> ReportResponse.ReportBoard {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        // print("요청 데이터: \(requestData)")
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .reportBoard)
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
            let decodeData = try decoder.decode(BaseResponse<ReportResponse.ReportBoard>.self, from: data)
            // print("ReportResponse.Report: \(decodeData.result)")
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
}
