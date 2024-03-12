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
            } else {
                SignInView(authViewModel: authViewModel)
            }
        }
        .environmentObject(pathModel)
    }
}

// MARK: - 홈 뷰
private struct HomeView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    @StateObject var answerViewModel: AnswerViewModel = .init()
    @StateObject var questionViewModel: QuestionViewModel = .init()
    
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
                            
                        case .todayAnswer:
                            TodayAnswerView()
                            
                        case .myPage:
                            MyPageView()
                            
                        case .profileEdit:
                            ProfileEditView()
                            
                        case .alert:
                            AlertView()
                            
                        case .report:
                            ReportView()
                            
                        default: EmptyView()
                        }
                    }
                
            case .collecting:
                SearchResultView(topTab: $tab)
                    .navigationDestination(for: PathType.self) { path in
                        switch path {
                        case .todayAnswer:
                            TodayAnswerView()
                            
                        case .answer:
                            AnswerView(viewModel: answerViewModel)
                            
                        case .confirmAnswer:
                            ConfirmAnswerView(viewModel: answerViewModel)
                            
                        case .searchKeyword:
                            SearchKeywordView(viewModel: answerViewModel)
                            
                        case .myPage:
                            MyPageView()
                            
                        case .profileEdit:
                            ProfileEditView()
                            
                        case .alert:
                            AlertView()
                            
                        case .report:
                            ReportView()
                            
                        default: EmptyView()
                        }
                    }
            }
        }
    }
}

// MARK: - 로그인 뷰
private struct SignInView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var authViewModel: AuthViewModel
    @State private var clickedLoginButton: Bool = false
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
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
                        
                    case .signUpCompleted:
                        SignUpCompletedView(authViewModel: authViewModel)
                        
                    default:
                        EmptyView()
                    }
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
            
            AppleLoginButton(authViewModel: authViewModel)
        }
        .background(Background.first)
    }
}

#Preview {
    MainView()
}
