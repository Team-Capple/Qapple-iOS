//
//  ProfileEditViewModel.swift
//  Capple
//
//  Created by 김민준 on 3/20/24.
//

import Foundation

final class ProfileEditViewModel: ObservableObject {
    
    @Published var nickname: String
    @Published var isKeyboardVisible = false
    @Published var keyboardBottomPadding: CGFloat = 0
    @Published var isNicknameFieldAvailable = true // 닉네임 유효성 검사
    @Published var isNicknameCanUse = false // 닉네임 중복 검사
    
    init() {
        nickname = ""
    }
}

// MARK: - Helper
extension ProfileEditViewModel {
    
    /// 특수 기호 체크 메서드
    /// 출처 : https://arc.net/l/quote/ojvfrfrb
    func koreaLangCheck(_ input: String) {
        let pattern = "^[가-힣a-zA-Z\\s]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: input.utf16.count)
            if regex.firstMatch(in: input, options: [], range: range) != nil {
                isNicknameFieldAvailable = true
                return
            }
        }
        isNicknameFieldAvailable = false
    }
}

// MARK: - 닉네임
extension ProfileEditViewModel {
    
    @MainActor
    func requestNicknameCheck() async {
        do {
            let check = try await NetworkManager.requestNicknameCheck(nickname)
            self.isNicknameCanUse = !check
        } catch {
            print("닉네임 중복 검사에 실패했습니다. 다시 시도해주세요")
        }
    }
}

// MARK: - 네트워킹
extension ProfileEditViewModel {
    
    /// 회원 정보 수정을 요청합니다.
    @MainActor
    func requestEditProfile() async throws {
        Task {
            do {
                let _ = try await NetworkManager.requestEditProfile(
                    request: .init(
                        nickname: nickname,
                        profileImage: nil
                    )
                )
            } catch {
                print("회원 정보 수정 실패")
            }
        }
    }
}
