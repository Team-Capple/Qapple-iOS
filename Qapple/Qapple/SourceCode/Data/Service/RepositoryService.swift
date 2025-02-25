//
//  RepositoryService.swift
//  Qapple
//
//  Created by 김민준 on 2/19/25.
//

import Foundation
import ComposableArchitecture
import QappleRepository

final class RepositoryService {
    
    typealias AccessToken = String
    
    static let shared = RepositoryService()
    private init() {}
    
    private var _server: Server?
    
    @Dependency(\.keychainService) var keychainService
    
    /// 현재 서버를 반환합니다.
    ///
    /// 기본 서버가 설정되어 있어야 합니다.(configureServer)
    var server: Server {
        guard let server = _server else {
            fatalError("기본 서버가 설정되지 않았습니다. configureServer(to:) 함수를 통해 기본 서버를 설정해주세요.")
        }
        return server
    }
    
    /// 기본 서버를 설정합니다.
    func configureServer(to server: Server) {
        guard _server == nil else {
            fatalError("서버는 한 번만 설정할 수 있습니다.")
        }
        _server = server
    }
    
    /// AccessToken 및 Server 설정, 토큰 재발급 로직을 추가해 API를 호출합니다.
    func request<T: Decodable>(
        handler: @escaping (Server, AccessToken) async throws -> T
    ) async throws -> T {
        let accessToken = try keychainService.fetchData(.accessToken)
        do {
            // 1. 네트워킹 성공 시, 기존 Token 값 사용
            return try await handler(self.server, accessToken)
        } catch NetworkError.authenticationFailed {
            
            do {
                // 2-1. 네트워킹 실패(403 에러 발생)시, Token 재발급
                let refresh = try await TokenAPI.refresh(
                    server: self.server,
                    accessToken: accessToken
                )
                
                // 2-2. Keychain 내 기존 Token값 업데이트
                try keychainService.createData(.accessToken, refresh.accessToken)
                try keychainService.createData(.refreshToken, refresh.refreshToken)
                
                // 2-3. 재발급 받은 Token으로 API 재호출
                return try await handler(self.server, refresh.accessToken)
            } catch {
                
                // 2-4. 만약 토큰 재발급에도 실패할 시, 로그인 화면으로 이동
                await QappleApp.mainFlowStore.send(.refreshTokenFailed)
                throw error
            }
        } catch {
            // 3. 이외의 네트워킹 오류 발생시 그대로 던지기
            throw error
        }
    }
}
