//
//  ProfileEditViewModel.swift
//  Capple
//
//  Created by 김민준 on 3/20/24.
//

import Foundation

final class ProfileEditViewModel: ObservableObject {
    
    @Published var nickName: String
    @Published var isKeyboardVisible = false
    @Published var keyboardBottomPadding: CGFloat = 0
    
    init() {
        nickName = ""
    }
}

// MARK: - 네트워킹
extension ProfileEditViewModel {
    
    /// 회원 정보 수정을 요청합니다.
    @MainActor
    func requestEditProfile() {
        Task {
            try await NetworkManager.requestEditProfile(
                request: .init(
                    nickname: nickName,
                    profileImage: nil
                )
            )
        }
    }
}
