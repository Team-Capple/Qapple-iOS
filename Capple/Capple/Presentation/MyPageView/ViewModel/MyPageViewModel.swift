//
//  MyPageViewModel.swift
//  Capple
//
//  Created by 김민준 on 3/19/24.
//

import Foundation

struct SectionInfo: Identifiable {
    let id: Int
    var sectionTitle: String
    var sectionContents: [String]
    var sectionIcons: [String]
}

final class MyPageViewModel: ObservableObject {
    
    // 섹션 정보
    let sectionInfos: [SectionInfo] = [
        SectionInfo(
            id: 0,
            sectionTitle: "문의 및 제보",
            sectionContents: [
                "문의하기",
            ],
            sectionIcons: [
                "InquiryIcon",
            ]
        ),
        SectionInfo(
            id: 1,
            sectionTitle: "계정 관리",
            sectionContents: [
                "로그아웃",
                "회원탈퇴"
            ],
            sectionIcons: [
                "SignOutIcon",
                "SignOutIcon"
            ]
        )
    ]
    
    // 프로필 정보
    @Published var myPageInfo: MemberResponse.MyPage
    
    init() {
        self.myPageInfo = .init(nickname: "튼튼한 민톨", profileImage: nil, joinDate: "2024.03.19 가입")
    }
}

// MARK: - 네트워킹
extension MyPageViewModel {
    
    /// 마이페이지 정보를 업데이트합니다.
    @MainActor
    func requestMyPageInfo() {
        Task {
            do {
                self.myPageInfo = try await NetworkManager.requestMyPage()
                print("마이페이지 정보 로드 성공")
            } catch {
                print("마이페이지 정보 로드 실패")
            }
        }
    }
}
