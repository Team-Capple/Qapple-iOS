//
//  NetworkManager+Member.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

// MARK: - 로그인 및 회원가입 Member
extension NetworkManager {
    
    /// 로그인 요청을 합니다.
    static func requestSignIn(request: MemberRequest.SignIn) async throws -> MemberResponse.SignIn {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .signIn)
        + "?code=\(request.code)" + "&deviceToken=\(request.deviceToken)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest \(response.statusCode)")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BaseResponse<MemberResponse.SignIn>.self, from: data)
            return decodeData.result
        } catch {
            print("Decode 에러")
            throw NetworkError.decodeFailed
        }
    }
    
    /// 회원가입 요청을 합니다.
    static func requestSignUp(request: MemberRequest.SignUp) async throws -> MemberResponse.SignUp {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        print("요청 데이터: \(request)")
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .signUp)
        guard let url = URL(string: urlString) else {
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
            let decodeData = try decoder.decode(BaseResponse<MemberResponse.SignUp>.self, from: data)
            print("MemberResponse.SignUp: \(decodeData.result)")
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
    
    /// 회원 탈퇴를 요청합니다.
    static func requestDeleteMember() async throws -> Bool {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .resignMember)
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("회원 가입 중 오류 발생")
            return false
        } else {
            print("회원 탈퇴 완료")
            return true
        }
    }
}

// MARK: - 닉네임 검사
extension NetworkManager {
    
    /// 닉네임 중복 검사를 요청합니다.
    static func requestNicknameCheck(_ nickName: String) async throws -> Bool {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .nickNameCheck) + "?nickname=\(nickName.removingPercentEncoding ?? "")"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("닉네임 중복 검사 실패")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(MemberResponse.NicknameCheck.self, from: data)
        return decodeData.result
    }
}

// MARK: - 마이페이지 조회 및 수정
extension NetworkManager {
    
    /// 마이페이지 정보를 요청합니다.
    static func requestMyPage() async throws -> MemberResponse.MyPage {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .myPage)
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        // 토큰 추가
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(for: request)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(BaseResponse<MemberResponse.MyPage>.self, from: data)
        // print("MemberResponse.MyPage: \(decodeData.result)")
        return decodeData.result
    }
    
    /// 마이페이지 정보를 수정합니다.
    static func requestEditProfile(request: MemberRequest.EditProfile) async throws -> MemberResponse.EditProfile {
        
        // JSON Request
        guard let requestData = try? JSONEncoder().encode(request) else {
            print("JSON Request 데이터 생성 실패")
            throw NetworkError.badRequest
        }
        
        print("요청 데이터: \(request)")
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .myPage)
        guard let url = URL(string: urlString) else {
            print("URL 객체 생성 실패")
            throw NetworkError.cannotCreateURL
        }
        
        var accessToken = ""
        
        do {
            accessToken = try SignInInfo.shared.token(.access)
        } catch {
            print("액세스 토큰 반환 실패")
        }
        
        // Request 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
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
            let decodeData = try decoder.decode(BaseResponse<MemberResponse.EditProfile>.self, from: data)
            // print("MemberResponse.EditProfile: \(decodeData.result)")
            return decodeData.result
        } catch {
            throw NetworkError.decodeFailed
        }
    }
}

// MARK: - 이메일 인증
extension NetworkManager {
    
    /// 회원가입 인증 코드를 이메일로 요청합니다.
    static func requestEmailCertificationCode(request: MemberRequest.EmailCertification) async throws -> Bool {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .emailCertification) + "?signUpToken=\(request.signUpToken)" + "&email=\(request.email)"
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(MemberResponse.EmailCertification.self, from: data)
        return decodeData.result
    }
    
    /// 인증 코드 확인을 요청합니다.
    static func requestCodeCertificationCode(request: MemberRequest.CodeCertification) async throws -> Bool {
        
        // URL 객체 생성
        let urlString = ApiEndpoints.basicURLString(path: .codeCertification) + "?signUpToken=\(request.signUpToken)" + "&email=\(request.email)" + "&certCode=\(request.certCode)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannotCreateURL")
            throw NetworkError.cannotCreateURL
        }
        
        // URLSession 생성
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(response)
        
        // 에러 체크
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            print("Error: badRequest")
            throw NetworkError.badRequest
        }
        
        // 디코딩
        let decoder = JSONDecoder()
        let decodeData = try decoder.decode(MemberResponse.CodeCertification.self, from: data)
        return decodeData.result
    }
}
