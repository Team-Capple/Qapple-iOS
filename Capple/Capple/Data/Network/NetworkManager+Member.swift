//
//  NetworkManager+Member.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

// MARK: - 멤버 관련 API
extension NetworkManager {
    
    /// 로그인 요청을 합니다.
    static func requestSignIn(request: MemberRequest.SignIn) async throws -> MemberResponse.SignIn {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .signIn) + "?code=\(request.code)"
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
            let decodeData = try decoder.decode(BaseResponse<MemberResponse.SignIn>.self, from: data)
            // print("QuestionResponse.MainQuestions: \(decodeData.result)")
            return decodeData.result
        } catch {
            print("Decode 에러")
            throw NetworkError.decodeFailed
        }
    }
}
