//
//  MyPageView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI
import MessageUI

struct MyPageView: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                NavigationBar()
                
                MyProfileSummary(
                    nickname: viewModel.myPageInfo.nickname,
                    joinDate: viewModel.myPageInfo.joinDate
                )
                .padding(.bottom, 24)
                
                MyPageList()
                    .padding(.horizontal, 24)
                
                Spacer()
            }
            .environmentObject(viewModel)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.requestMyPageInfo()
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    var body: some View {
        CustomNavigationBar(
            leadingView: {},
            principalView: {
                Text("프로필")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {},
            backgroundColor: Background.second)
    }
}

// MARK: - MyPageList

private struct MyPageList: View {
    var body: some View {
        VStack(spacing: 48) {
            QuestionAnswerSection()
            InquiriesReportsSection()
            AccountSection()
        }
    }
}

// MARK: - QuestionAnswerSection

private struct QuestionAnswerSection: View {
    
    @EnvironmentObject private var pathModel: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MyPageSectionTitle(title: "질문/답변")
                .padding(.bottom, 12)
            
            MyPageSectionCell(
                title: "내 답변",
                icon: .writeAnswerIcon,
                tapAction: {
                    pathModel.pushView(screen: MyProfilePathType.writtenAnswer)
                }
            )
        }
    }
}

// MARK: - InquiriesReportsSection

private struct InquiriesReportsSection: View {
    
    @EnvironmentObject private var pathModel: Router
    
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var isEmailDisabledAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MyPageSectionTitle(title: "문의 및 제보")
                .padding(.bottom, 12)
            
            MyPageSectionCell(
                title: "문의하기",
                icon: .inquiryIcon,
                tapAction: {
                    if !MFMailComposeViewController.canSendMail() {
                        isEmailDisabledAlert.toggle()
                    } else {
                        isShowingMailView.toggle()
                    }
                }
            )
        }
        .alert("메일 앱에 로그인할 수 없어요", isPresented: $isEmailDisabledAlert) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("메일 앱에 로그인하거나\n공식 메일 주소로 문의주세요\n(0.team.capple@gmail.com)")
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $mailResult)
        }
    }
}

// MARK: - AccountSection

private struct AccountSection: View {
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: MyPageViewModel
    
    @State private var isLogOutAlertPresented = false
    @State private var isResignAlertPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MyPageSectionTitle(title: "계정 관리")
                .padding(.bottom, 12)
            
            MyPageSectionCell(
                title: "로그아웃",
                icon: .signOutIcon,
                tapAction: {
                    isLogOutAlertPresented.toggle()
                    HapticManager.shared.notification(type: .warning)
                }
            )
            
            MyPageSectionCell(
                title: "회원탈퇴",
                icon: .resign,
                isDistructive: true,
                tapAction: {
                    isResignAlertPresented.toggle()
                    HapticManager.shared.notification(type: .warning)
                }
            )
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
        .alert("정말 탈퇴하시겠어요?", isPresented: $isResignAlertPresented) {
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
    }
}

// MARK: - Preview

#Preview {
    MyPageView()
        .environmentObject(Router(pathType: .myProfile))
        .environmentObject(AuthViewModel())
}
