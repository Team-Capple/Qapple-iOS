//
//  MyPageView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct MyPageView: View {
    private let sectionInfos: [SectionInfo] = [
        SectionInfo(
            sectionTitle: "질문/답변",
            sectionContents: [
                "작성한 답변",
                "좋아요 한 질문",
                "좋아요 한 답변"
            ],
            sectionIcons: [
                "WriteAnswerIcon",
                "LikeQuestionIcon",
                "LikeAnswerIcon"]
        ),
        SectionInfo(
            sectionTitle: "문의 및 제보",
            sectionContents: [
                "문의하기",
                "캐플 디스코드",
                "캐플 인스타",
                "캐플 오픈채팅방"
            ],
            sectionIcons: [
                "InquiryIcon",
                "DiscodeIcon",
                "InstagramIcon",
                "OpenChatIcon"
            ]
        ),
        SectionInfo(
            sectionTitle: "계정 관리",
            sectionContents: [
                "로그아웃"
            ],
            sectionIcons: [
                "SignOutIcon"
            ]
        )
    ]
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) },
                principalView: {
                    Text("프로필")
                        .font(Font.pretendard(.semiBold, size: 17))
                        .foregroundStyle(TextLabel.main)
                    
                },
                trailingView: {
                        NavigationLink(destination: ProfileEditView()) {
                            Text("수정")
                                .foregroundStyle(TextLabel.sub3)
                        }
                },
                backgroundColor: Background.second)
            ScrollView {
                
                VStack(alignment: .leading, spacing: 0) {
                    MyProfileSummary()
                    
                    ForEach(sectionInfos.indices, id: \.self) { index in
                        MyPageSection(sectionInfo: sectionInfos[index])
                    }
                }
            }
        }
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SectionInfo {
    var sectionTitle: String
    var sectionContents: [String]
    var sectionIcons: [String]
}

#Preview {
    MyPageView()
}
