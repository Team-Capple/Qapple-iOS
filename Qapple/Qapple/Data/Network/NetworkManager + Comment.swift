//
//  NetworkManager + Comment.swift
//  Qapple
//
//  Created by 문인범 on 9/4/24.
//

import Foundation

// MARK: - 댓글(Comment) 관련 API
extension NetworkManager {
    
    
    static func fetchComments(boardId: Int) async throws -> CommentResponse.Comments {
        let urlString = ApiEndpoints.basicURLString(path: .comments)
        
        guard let url = URL(string: "\(urlString)/\(boardId)") else {
            print("잘못된 URL 입니다! in CommentView")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.badRequest
            }
            
            let result = try JSONDecoder().decode(BaseResponse<CommentResponse.Comments>.self, from: data)
            
            print(result)
            
            return result.result
        } catch {
            print(String(describing: error))
        }
        
        throw NetworkError.decodeFailed
    }
    
    static func postComment(requestBody: CommentRequest.UploadComment) async throws {
        let urlString = ApiEndpoints.basicURLString(path: .createComment)
        
        guard let url = URL(string: "\(urlString)/\(requestBody.boardId)") else {
            print("잘못된 URL 입니다! in CommentView")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        do {
            let bodyText = requestBody.content
            let body = try JSONEncoder().encode(bodyText)
            
            request.httpBody = body
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.badRequest
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    
    
    static func likeComment(commentId: Int) async throws {
        let urlString = ApiEndpoints.basicURLString(path: .likeComment)
        
        guard let url = URL(string: "\(urlString)/\(commentId)") else {
            print("잘못된 URL 입니다! in CommentView")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.badRequest
            }
            
        } catch {
            print(String(describing: error))
        }
    }
}
