//
//  SignInView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/11/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var authViewModel: AuthViewModel = .init()
    @StateObject private var pathModel = PathModel()
    
    var body: some View {
        Group {
            if authViewModel.isSignIn {
                HomeView()
                    .environmentObject(pathModel)
                    .environmentObject(authViewModel)
            } else {
                SignInView()
                    .environmentObject(pathModel)
                    .environmentObject(authViewModel)
            }
        }
    }
}

// MARK: - 홈 뷰
private struct HomeView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject var authViewModel: AuthViewModel = .init()
    @StateObject var answerViewModel: AnswerViewModel = .init()
    
    @State private var tab: Tab = .answering
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            switch tab {
            case .answering:
                TodayQuestionView(tab: $tab)
                    .navigationDestination(for: PathType.self) { path in
                        switch path {
                        case .answer:
                            AnswerView(viewModel: answerViewModel)
                            
                        case .confirmAnswer:
                            ConfirmAnswerView(viewModel: answerViewModel)
                            
                        case .searchKeyword:
                            SearchKeywordView(viewModel: answerViewModel)
                
                       case .todayAnswer(let questionId, let questionContent):
                            TodayAnswerView(questionId: questionId, tab: $tab, questionContent: questionContent)

                        case .myPage:
                            MyPageView()
                            
                        case let .profileEdit(nickname):
                            ProfileEditView(nickName: nickname)
                            
                        case .alert:
                            AlertView()
                            
                        case .report:
                            ReportView()
                            
                        default: EmptyView()
                        }
                    }
                
            case .collecting:
                SearchResultView(viewModel: QuestionViewModel(), tab: $tab)
                  .navigationDestination(for: PathType.self) { path in
                        switch path {
                        case let .todayAnswer(questionId, questionContent):
                            TodayAnswerView(questionId: questionId, tab: $tab, questionContent: questionContent)
                            
                        case .answer:
                            AnswerView(viewModel: answerViewModel)
                            
                        case .confirmAnswer:
                            ConfirmAnswerView(viewModel: answerViewModel)
                            
                        case .searchKeyword:
                            SearchKeywordView(viewModel: answerViewModel)
                            
                        case .myPage:
                            MyPageView()
                            
                        case let .profileEdit(nickname):
                            ProfileEditView(nickName: nickname)
                            
                        case .alert:
                            AlertView()
                            
                        case .report:
                            ReportView()
                            
                        default: EmptyView()
                        }
                    }
            }
        }
        .onAppear {
            NotificationManager.shared.requestNotificationPermission()
            NotificationManager.shared.schedule()
        }
    }
}

// MARK: - 로그인 뷰
private struct SignInView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var clickedLoginButton: Bool = false
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            ZStack {
                signInView
                    .navigationDestination(for: PathType.self) { path in
                        switch path {
                        case .email:
                            SignUpEmailView()
                            
                        case .authCode:
                            SignUpAuthCodeView()
                            
                        case .inputNickName:
                            SignUpNicknameView()
                            
                        case .agreement:
                            SignUpTermsAgreementView()
                            
                        case .privacy:
                            SignUpPrivacyView()
                            
                        case .signUpCompleted:
                            SignUpCompletedView()
                            
                        default:
                            EmptyView()
                        }
                    }
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()) // 로딩 바 스타일 설정
                    .scaleEffect(2) // 크기 조절
                    .padding(.top, 60)
                    .opacity(authViewModel.isSignInLoading ? 1 : 0) // 로딩 중에만 보이도록 설정
                    .tint(.wh)
            }
        }
        .onChange(of: authViewModel.isSignUp) { _, isSignUp in
            if isSignUp {
                pathModel.paths.append(.email)
            }
        }
    }
    
    var signInView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(.capple)
                .resizable()
                .scaledToFit()
                .frame(width: 400)
            
            Text("CAPPLE")
                .foregroundStyle(Color.main)
                .font(Font.pretendard(.extraBold, size: 56))
                .padding(.top, -40)
            
            Spacer()
            
            AppleLoginButton()
                .disabled(authViewModel.isSignInLoading)
        }
        .background(Background.first)
    }
}

#Preview {
    MainView()
}
