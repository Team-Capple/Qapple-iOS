//
//  MyPageView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: MyPageViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.paths.removeLast()
                }},
                principalView: {
                    Text("프로필")
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {},
                backgroundColor: Background.second)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    MyProfileSummary(
                        nickname: viewModel.myPageInfo.nickname,
                        joinDate: viewModel.myPageInfo.joinDate
                    )
                    
                    ForEach(viewModel.sectionInfos, id: \.id) { index in
                        
                        // 문의 및 제보
                        if index.id == 0 {
                            MyPageSection(sectionInfo: index, sectionActions: [
                                
                                // 문의하기
                                {
                                    print("문의하기")
                                }
                            ])
                        }
                        
                        // 계정 관리
                        else if index.id == 1 {
                            MyPageSection(sectionInfo: index, sectionActions: [
                                
                                // 문의하기
                                {
                                    print("로그아웃")
                                },
                                
                                // 회원탈퇴
                                {
                                    print("회원 탈퇴")
                                }
                            ])
                        }
                    }
                }
            }
        }
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.requestMyPageInfo()
        }
    }
}

#Preview {
    MyPageView()
}
