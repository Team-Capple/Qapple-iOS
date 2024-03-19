//
//  MyPageView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI
import MessageUI

struct MyPageView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: MyPageViewModel = .init()
    
    @State private var isLogOutAlertPresented = false
    
    // 이메일 관련 변수
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isEmailDisabledAlert = false
    
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
                                    // 메일 앱을 사용할 수 없는 경우
                                    if !MFMailComposeViewController.canSendMail() {
                                        isEmailDisabledAlert.toggle()
                                    } else {
                                        isShowingMailView.toggle()
                                    }
                                }
                            ])
                        }
                        
                        // 계정 관리
                        else if index.id == 1 {
                            MyPageSection(sectionInfo: index, sectionActions: [
                                
                                // 로그아웃
                                {
                                    isLogOutAlertPresented.toggle()
                                },
                                
                                // 회원탈퇴
                                {
                                    print("회원탈퇴")
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
        .alert("로그아웃 할까요?", isPresented: $isLogOutAlertPresented) {
            HStack {
                Button("취소", role: .cancel, action: {})
                Button("확인", role: .none, action: {
                    pathModel.paths.removeAll()
                    authViewModel.isSignIn = false
                })
            }
        } message: {
            Text("로그아웃 됩니당")
        }
        .alert("메일 APP을 사용할 수 없어요", isPresented: $isEmailDisabledAlert) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("메일 APP 설치 후 로그인 해주세요.\n혹은 공식 문의 메일 - 0.team.capple@gmail.com")
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $mailResult)
        }
    }
}

#Preview {
    MyPageView()
}
