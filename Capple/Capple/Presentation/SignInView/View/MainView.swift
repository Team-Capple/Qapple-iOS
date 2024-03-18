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
                        case let .answer(mainQuestion):
                            AnswerView(viewModel: answerViewModel, mainQuestion: mainQuestion)
                            
                        case .confirmAnswer:
                            ConfirmAnswerView(viewModel: answerViewModel)
                            
                        case .searchKeyword:
                            SearchKeywordView(viewModel: answerViewModel)
                
                       case .todayAnswer(let questionId, let questionContent):
                            TodayAnswerView(questionId: questionId, tab: $tab, questionContent: questionContent)

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
                SearchResultView(viewModel: QuestionViewModel(), tab: $tab)
                  .navigationDestination(for: PathType.self) { path in
                        switch path {
                        case .todayAnswer:
                            TodayAnswerView(questionId: 1, tab: $tab, questionContent: "default질문은 이것입니다")
                            
                            // MARK: - 한톨 코멘트
                            // 답변하기 뷰 이동할 때 메인 질문만 넘겨주면 되서 요렇게 변경했슴다!
                        case let .answer(mainQuestion):
                            AnswerView(viewModel: answerViewModel, mainQuestion: mainQuestion)
                            
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
    @EnvironmentObject var authViewModel: AuthViewModel
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
                        
                    case .privacy:
                        SignUpPrivacyView()
                        
                    case .signUpCompleted:
                        SignUpCompletedView()
                        
                    default:
                        EmptyView()
                    }
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
        }
        .background(Background.first)
    }
}

#Preview {
    MainView()
}
