//
//  NetworkManager+Answer.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

// MARK: - 답변 관련 API
extension NetworkManager {
    
    /// 특정 질문에 대한 답변을 조회합니다.
    static func fetchAnswersOfQuestion(request: AnswerRequest.AnswersOfQuestion) async throws -> AnswerResponse.AnswersOfQuestion {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .answersOfQuestion) + "/\(request.questionId)?" + "keyword=\(request.keyword ?? "")&size=\(request.size ?? 10)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SignInInfo.shared.accessToken())", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
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
