//
//  NetworkManager+UNIVCERT.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

extension NetworkManager {
    
    /// 대학 메일 인증을 요청합니다.
    static func requestUniversityMailAuth(request: UNIVCERTRequest.UserMailAuthentication) async throws -> UNIVCERTResponse.UserMailAuthentication {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        print("요청 데이터: \(request)")
        
        // URL 객체 생성
        guard let url = URL(string: "https://univcert.com/api/v1/certify") else {
            print("URL 객체 생성 실패")
            throw NetworkError.cannotCreateURL
        }
        
        // Request 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        print(data)
        print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(UNIVCERTResponse.UserMailAuthentication.self, from: data)
        print("UNIVCERTResponse.UserMailAuthentication: \(decodeData)")
        return decodeData
    }
    
    /// 대학 메일 인증코드를 확인합니다.
    static func requestUniversityCertifyCode(request: UNIVCERTRequest.CertifyCode) async throws -> UNIVCERTResponse.CertifyCode {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        print("요청 데이터: \(request)")
        
        // URL 객체 생성
        guard let url = URL(string: "https://univcert.com/api/v1/certifycode") else {
            print("URL 객체 생성 실패")
            throw NetworkError.cannotCreateURL
        }
        
        // Request 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        print(data)
        print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(UNIVCERTResponse.CertifyCode.self, from: data)
            print("UNIVCERTResponse.CertifyCode: \(decodeData)")
            return decodeData
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    /// 넘겨받은 이메일의 대학 메일 인증을 초기화합니다.
    static func requestClearEmailUniversity(request: UNIVCERTRequest.ClearEmail, email: String) async throws -> Bool {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        print("요청 데이터: \(request)")
        
        // URL 객체 생성
        guard let url = URL(string: "https://univcert.com/api/v1/clear/\(email)@postech.ac.kr") else {
            print("URL 객체 생성 실패")
            throw NetworkError.cannotCreateURL
        }
        
        // Request 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // URLSession 실행
        let (data, response) = try await URLSession.shared.upload(for: request, from: requestData)
        print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("인증 목록 초기화에 실패했습니다.")
            return false
        } else {
            print("인증 목록이 정상적으로 초기화 되었습니다.")
            return true
        }
    }
}
