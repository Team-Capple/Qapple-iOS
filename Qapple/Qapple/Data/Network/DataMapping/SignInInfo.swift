//
//  SignInInfo.swift
//  Capple
//
//  Created by 김민준 on 3/17/24.
//

import Foundation

final class SignInInfo {
    
    enum KeyChainError: Error {
        case notFound // 키체인 찾을 수 없음
        case undexpectedData // 예상치 못한 데이터
        case unHandledError(status: OSStatus) // 예외 처리에 실패한 에러
    }
    
    enum TokenType: String {
        case access = "accessToken"
        case refresh = "refreshToken"
    }
    
    static let shared = SignInInfo()
    private init() {}
    
    private var refreshTokenValue: String = ""
    
    /// 키체인에서 액세스 토큰을 반환합니다.
    func token(_ type: TokenType) throws -> String {
        
        // 1. 키체인에서 검색할 query
        let searchQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type.rawValue,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        // 2. 검색 결과를 담을 변수 생성
        var result: CFTypeRef?
        
        // 3. 키체인에 쿼리를 이용한 검색 및 반환
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &result) // inOut 파라미터로 변수에 넣어주게 됨.
        
        // 4. 검색 결과가 잘 들어왔는지 확인
        guard status != errSecItemNotFound else {
            print("키체인 검색 결과 없음")
            throw KeyChainError.notFound
        }
        
        guard status == errSecSuccess else {
            print("키체인 검색 실패")
            throw KeyChainError.unHandledError(status: status)
        }
        
        // 5. 검색 결과를 Dictionary로 변환
        guard let existingItem = result as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            print("예상치 못한 데이터 반환")
            throw KeyChainError.undexpectedData
        }
        
        // 6. 최종 토큰 반환
        return token
    }
    
    /// 키체인에 토큰을  생성합니다.
    func createToken(_ type: TokenType, token: String) throws {
        
        // 1. 토큰 문자열을 Data로 변환
        let tokenData = token.data(using: .utf8)!
        
        // 2. 키체인 생성용 쿼리
        let createQuery: [CFString: Any] = [
            kSecClass: kSecClassKey, // 키체인 item 클래스: kSecClassKey
            kSecAttrType: type.rawValue, // 키체인 검색용 attribute: 토큰 라벨
            kSecValueData: tokenData // 암호화가 필요한 키체인 item(토큰)
        ]
        
        // 3. 키체인에 쿼리를 이용해 추가
        let status = SecItemAdd(createQuery as CFDictionary, nil)
        
        // 4. 키체인 추가가 잘 되었는지 확인
        if status == errSecSuccess {
            print("키체인 생성 성공")
        } else if status == errSecDuplicateItem {
            // 4-1. 만약 이미 존재한다면, 기존 키체인 item 업데이트
            print("키체인 업데이트 예정")
            try updateToken(type, value: tokenData)
            
        } else {
            print("키체인 생성 실패")
            throw KeyChainError.unHandledError(status: status)
        }
    }
    
    /// 키체인 내 토큰을 업데이트합니다.
    private func updateToken(_ type: TokenType, value: Any) throws {
        
        // 1. 기존 키체인을 찾기 위한 쿼리
        let originalQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrType: type.rawValue
        ]
        
        // 2. 업데이트할 데이터를 담고 있는 쿼리
        let updateQuery: [CFString: Any] = [
            kSecValueData: value
        ]
        
        // 3. 키체인에 쿼리를 이용해 업데이트
        let status = SecItemUpdate(originalQuery as CFDictionary, updateQuery as CFDictionary)
        
        // 4. 키체인 업데이트가 잘 되었는지 확인
        if status == errSecSuccess {
            print("키체인 업데이트 성공")
        } else {
            print("키체인 업데이트 실패")
            throw KeyChainError.unHandledError(status: status)
        }
    }
    
    // MARK: - Refresh Token
    
    /// 리프레쉬 토큰을 반환합니다.
//    func refreshToken() -> String {
//        return refreshTokenValue
//    }
    
//    /// 리프레쉬 토큰을 업데이트합니다.
//    func updateRefreshToken(_ token: String) {
//        refreshTokenValue = token
//    }
}
