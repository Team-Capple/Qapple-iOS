//
//  MemberRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/30/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation

struct MemberRepository {
    var signIn: (_ code: String) async throws -> Bool
    var signUp: (_ email: String, _ nickname: String) async throws -> Void
    var sendCertificationEmail: (_ email: String) async throws -> Bool
    var checkAuthCode: (_ email: String, _ certCode: String) async throws -> Bool
    var checkNicknameDuplicate: (_ nickname: String) async throws -> Bool
    var fetchMyPage: () async throws -> MyProfile
    var editMyPage: (_ nickname: String, _ profileImage: String?) async throws -> Void
    var resign: () async throws -> Void
}

// MARK: - DependencyKey

extension MemberRepository: DependencyKey {
    
    @Dependency(\.keychainService) static var keychainService
    
    private static let repositoryService = RepositoryService.shared
    
    static let liveValue = Self(
        signIn: { code in
            let deviceToken = try keychainService.fetchData(.deviceToken)
            let response = try await MemberAPI.signIn(
                code: code,
                deviceToken: deviceToken,
                server: repositoryService.server
            )
            try keychainService.createData(.accessToken, response.accessToken ?? "")
            try keychainService.createData(.refreshToken, response.refreshToken ?? "")
            return response.isMember
        },
        signUp: { email, nickname in
            let refreshToken = try keychainService.fetchData(.refreshToken)
            let deviceToken = try keychainService.fetchData(.deviceToken)
            let response = try await MemberAPI.signUp(
                signUpToken: refreshToken,
                email: email,
                nickname: nickname,
                deviceToken: deviceToken,
                server: repositoryService.server
            )
            try keychainService.createData(.accessToken, response.accessToken ?? "")
            try keychainService.createData(.refreshToken, response.refreshToken ?? "")
        },
        sendCertificationEmail: { email in
            let refreshToken = try keychainService.fetchData(.refreshToken)
            let response = try await MemberAPI.sendCertificationEmail(
                signUpToken: refreshToken,
                email: email,
                server: repositoryService.server
            )
            return response
        },
        checkAuthCode: { email, certCode in
            let refreshToken = try keychainService.fetchData(.refreshToken)
            let response = try await MemberAPI.checkAuthCode(
                signUpToken: refreshToken,
                email: email,
                certCode: certCode,
                server: repositoryService.server
            )
            return response
        },
        checkNicknameDuplicate: { nickname in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await MemberAPI.checkNicknameDuplicate(
                    nickname: nickname,
                    server: server,
                    accessToken: accessToken
                )
            }
            return response
        },
        fetchMyPage: {
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await MemberAPI.fetchProfile(
                    server: server,
                    accessToken: accessToken
                )
            }
            return MyProfile(
                nickname: response.nickname,
                profileImage: response.profileImage,
                joinDate: response.joinDate
            )
        },
        editMyPage: { nickname, profileImage in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await MemberAPI.updateProfile(
                    nickname: nickname,
                    profileImage: profileImage,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        resign: {
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await MemberAPI.resign(
                    server: server,
                    accessToken: accessToken
                )
            }
        }
    )
    
    static let previewValue = Self(
        signIn: { code in
            print("로그인 요청: code=\(code)")
            return true
        },
        signUp: { email, nickname in
            print("회원가입 요청: email=\(email), nickname=\(nickname)")
        },
        sendCertificationEmail: { email in
            print("email=\(email)")
            return true
        },
        checkAuthCode: { email, certCode in
            print("인증 코드 확인: email=\(email), code=\(certCode)")
            return certCode == "12345"
        },
        checkNicknameDuplicate: { nickname in
            print("닉네임 중복 확인: \(nickname)")
            return nickname != "이미사용중"
        },
        fetchMyPage: {
            MyProfile(nickname: "프리뷰 유저", profileImage: nil, joinDate: "2025-01-31")
        },
        editMyPage: { nickname, profileImage in
            print("프로필 수정: nickname=\(nickname), profileImage=\(profileImage ?? "없음")")
        },
        resign: {
            print("회원 탈퇴 요청")
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var memberRepository: MemberRepository {
        get { self[MemberRepository.self] }
        set { self[MemberRepository.self] = newValue }
    }
}
