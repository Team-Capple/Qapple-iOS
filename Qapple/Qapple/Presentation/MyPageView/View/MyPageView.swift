//
//  MyPageView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI
import MessageUI

struct MyPageView: View {
    
    @EnvironmentObject var pathModel: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: MyPageViewModel = .init()
    
    // 이메일 관련 변수
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isEmailDisabledAlert = false
    
    // 로그아웃 관련 변수
    @State private var isLogOutAlertPresented = false
    
    // 회원탈퇴 관련 변수
    @State private var isDeleteMemeberAlertPresented = false
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leadingView: {},
                    principalView: {
                        Text("프로필")
                            .font(Font.pretendard(.semiBold, size: 15))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {
                        Button {
                            pathModel.pushView(
                                screen: MyProfilePathType.profileEdit(nickname: viewModel.myPageInfo.nickname)
                            )
                        } label: {
                            Text("수정")
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(TextLabel.sub2)
                        }
                    },
                    backgroundColor: Background.second)
                
                VStack(alignment: .leading, spacing: 0) {
                    MyProfileSummary(
                        nickname: viewModel.myPageInfo.nickname,
                        joinDate: viewModel.myPageInfo.joinDate
                    )
                    
                    ForEach(viewModel.sectionInfos, id: \.id) { index in
                        
                        // 질문/답변
                        if index.id == 0 {
                            MyPageSection(sectionInfo: index, sectionActions: [
                                {
                                    pathModel.pushView(screen: MyProfilePathType.writtenAnswer)
                                }
                            ])
                        }
                        
                        // 문의 및 제보
                        if index.id == 1 {
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
                        else if index.id == 2 {
                            MyPageSection(sectionInfo: index, sectionActions: [
                                
                                // 로그아웃
                                {
                                    isLogOutAlertPresented.toggle()
                                    HapticManager.shared.notification(type: .warning)
                                },
                                
                                // 회원탈퇴
                                {
                                    isDeleteMemeberAlertPresented.toggle()
                                    HapticManager.shared.notification(type: .warning)
                                }
                            ])
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.requestMyPageInfo()
                }
            }
            .alert("메일 앱에 로그인할 수 없어요", isPresented: $isEmailDisabledAlert) {
                Button("확인", role: .none, action: {})
            } message: {
                Text("메일 앱에 로그인하거나\n공식 메일 주소로 문의주세요\n(0.team.capple@gmail.com)")
            }
            .alert("로그아웃 할까요?", isPresented: $isLogOutAlertPresented) {
                HStack {
                    Button("취소", role: .cancel, action: {})
                    Button("로그아웃", role: .none, action: {
                        pathModel.popToRoot()
                        authViewModel.isSignIn = false
                        viewModel.signOut()
                    })
                }
            } message: {
                Text("언제든 다시 돌아올 수 있습니다!")
            }
            .alert("정말 탈퇴하시겠어요?", isPresented: $isDeleteMemeberAlertPresented) {
                HStack {
                    Button("취소", role: .cancel, action: {})
                    Button("회원 탈퇴", role: .destructive, action: {
                        viewModel.requestDeleteMember()
                        pathModel.popToRoot()
                        authViewModel.isSignIn = false
                        authViewModel.isSignUp = false
                    })
                }
            } message: {
                Text("탈퇴하면 계정은 복구되지 않아요\n단, 이미 작성한 답변은 남아있어요")
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: $mailResult)
            }
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(Router(pathType: .myProfile))
        .environmentObject(AuthViewModel())
}
