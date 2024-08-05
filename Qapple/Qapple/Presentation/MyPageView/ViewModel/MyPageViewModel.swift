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
    
    @Published var isDeletedMember: Bool
    
    // 섹션 정보
    let sectionInfos: [SectionInfo] = [
        SectionInfo(
            id: 0,
            sectionTitle: "질문/답변",
            sectionContents: [
                "작성한 답변",
            ],
            sectionIcons: [
                "WriteAnswerIcon",
            ]
        ),
        
        SectionInfo(
            id: 1,
            sectionTitle: "문의 및 제보",
            sectionContents: [
                "문의하기",
            ],
            sectionIcons: [
                "InquiryIcon",
            ]
        ),
        
        SectionInfo(
            id: 2,
            sectionTitle: "계정 관리",
            sectionContents: [
                "로그아웃",
                "회원탈퇴"
            ],
            sectionIcons: [
                "SignOutIcon",
                "resign"
            ]
        )
    ]
    
    // 프로필 정보
    @Published var myPageInfo: MemberResponse.MyPage
    
    init() {
        self.myPageInfo = .init(nickname: "", profileImage: nil, joinDate: "")
        self.isDeletedMember = false
    }
}

// MARK: - 네트워킹
extension MyPageViewModel {
    
    /// 마이페이지 정보를 업데이트합니다.
    @MainActor
    func requestMyPageInfo() async {
        do {
            self.myPageInfo = try await NetworkManager.requestMyPage()
        } catch {
            print("마이페이지 정보 로드 실패")
        }
    }
    
    /// 로그아웃을 진행합니다.
    @MainActor
    func signOut() {
        try? SignInInfo.shared.createUserID("")
    }
    
    /// 회원 탈퇴를 요청합니다.
    @MainActor
    func requestDeleteMember() {
        Task {
            self.isDeletedMember = try await NetworkManager.requestDeleteMember()
            try? SignInInfo.shared.createUserID("")
        }
    }
}
