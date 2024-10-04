//
//  NetworkManager + Comment.swift
//  Qapple
//
//  Created by 문인범 on 9/4/24.
//

import Foundation

// MARK: - 댓글(Comment) 관련 API
extension NetworkManager {
    
    // 해당 게시글에 댓글을 불러옵니다.
    static func fetchComments(boardId: Int, threshold: Int?, pageSize: Int) async throws -> CommentResponse.Comments {
        let urlString = ApiEndpoints.basicURLString(path: .comments)
        
        guard let url = URL(string: "\(urlString)/\(boardId)?pageSize=25") else {
            print("잘못된 URL 입니다! in CommentView")
            throw NetworkError.cannotCreateURL
        }
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if let threshold = threshold {
            urlComponent.queryItems = [
                .init(name: "threshold", value: String(threshold)),
                .init(name: "pageSize", value: String(pageSize))
            ]
        } else {
            urlComponent.queryItems = [
                .init(name: "pageSize", value: String(pageSize))
            ]
        }
        
        guard let url = urlComponent.url else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(try SignInInfo.shared.token(.access))", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.badRequest
            }
            
            let result = try JSONDecoder().decode(BaseResponse<CommentResponse.Comments>.self, from: data)
            
            return result.result
        } catch {
            throw NetworkError.badRequest
        }
    }
    
    // 댓글을 업로드 합니다.
    static func postComment(id: Int, requestBody: CommentRequest.UploadComment) async throws {
        let urlString = ApiEndpoints.basicURLString(path: .createComment)
        
        guard let url = URL(string: "\(urlString)/\(id)") else {
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
            let body = try JSONEncoder().encode(requestBody)
            
            request.httpBody = body
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.badRequest
            }
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    // 해당 댓글에 좋아요를 추가 or 취소 합니다.
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
            throw NetworkError.badRequest
        }
    }
    
    // 자신의 댓글을 삭제합니다.
    static func deleteComment(commentId: Int) async throws {
        let urlString = ApiEndpoints.basicURLString(path: .comments)
        
        guard let url = URL(string: "\(urlString)/\(commentId)") else {
            print("잘못된 URL 입니다! in Delete")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
            throw NetworkError.badRequest
        }
    }
    
    // 타인의 댓글을 신고합니다.
    static func reportComment(requestBody: CommentRequest.ReportComment) async throws {
        let urlString = ApiEndpoints.basicURLString(path: .commentReport)
        
        guard let url = URL(string: "\(urlString)") else {
            print("잘못된 URL 입니다! in Delete")
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
            let body = try JSONEncoder().encode(requestBody)
            request.httpBody = body
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.badRequest
            }
            
        } catch {
            throw NetworkError.badRequest
        }
    }
}
