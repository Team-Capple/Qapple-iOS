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
    
    @State private var tab: Tab = .todayQuestion
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            VStack(spacing: 0) {
                CustomTabBar(tab: $tab)
                
                TabView(selection: $tab) {
                    TodayQuestionView()
                        .navigationDestination(for: PathType.self) { path in
                            switch path {
                            case .answer(let questionId, let questionContent):
                                AnswerView(
                                    viewModel: answerViewModel,
                                    questionId: questionId,
                                    questionContent: questionContent
                                )
                                
                            case .confirmAnswer:
                                ConfirmAnswerView(viewModel: answerViewModel)
                                
                            case .searchKeyword:
                                SearchKeywordView(viewModel: answerViewModel)
                                
                            case .completeAnswer:
                                CompleteAnswerView(viewModel: answerViewModel)
                                
                            case .todayAnswer(let questionId, let questionContent):
                                TodayAnswerView(
                                    questionId: questionId,
                                    questionContent: questionContent
                                )
                                
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
                        .tag(Tab.todayQuestion)
                    
                    SearchResultView()
                        .navigationDestination(for: PathType.self) { path in
                            switch path {
                            case .todayAnswer(let questionId, let questionContent):
                                TodayAnswerView(
                                    questionId: questionId,
                                    questionContent: questionContent
                                )
                                
                            case .answer(let questionId, let questionContent):
                                AnswerView(
                                    viewModel: answerViewModel,
                                    questionId: questionId,
                                    questionContent: questionContent
                                )
                                
                            case .confirmAnswer:
                                ConfirmAnswerView(viewModel: answerViewModel)
                                
                            case .searchKeyword:
                                SearchKeywordView(viewModel: answerViewModel)
                                
                            case .completeAnswer:
                                CompleteAnswerView(viewModel: answerViewModel)
                                
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
                        .tag(Tab.questionList)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                NotificationManager.shared.requestNotificationPermission()
                NotificationManager.shared.schedule()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
                Color(.clear)
                    .ignoresSafeArea()
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.12, green: 0.12, blue: 0.13).opacity(0), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.93, green: 0.26, blue: 0.38).opacity(0.56), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0.55),
                            endPoint: UnitPoint(x: 0.5, y: 2)
                        )
                    )
                    .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                
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
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 120)
            
            Text("우리끼리\n익명으로\n답변하기")
                .font(.pretendard(.extraBold, size: 32))
                .foregroundStyle(TextLabel.main)
                .lineSpacing(12)
            
            Spacer().frame(height: 24)
            
            Text("캐플.")
                .font(.pretendard(.extraBold, size: 48))
                .foregroundStyle(BrandPink.subText)
            
            Spacer()
            
            AppleLoginButton()
                .disabled(authViewModel.isSignInLoading)
                .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - 커스텀 탭바
private struct CustomTabBar: View {
    
    @Binding var tab: Tab
    
    var body: some View {
        HStack(spacing: 28) {
            Spacer()
            Button {
                tab = .todayQuestion
            } label: {
                Text("오늘의질문")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(tab == .todayQuestion ? TextLabel.main : TextLabel.sub4)
            }

            Button {
                tab = .questionList
            } label: {
                Text("질문리스트")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(tab == .questionList ? TextLabel.main : TextLabel.sub4)
            }
            Spacer()
        }
        .frame(height: 32)
        .background(Background.second)
    }
}

#Preview {
    MainView()
}
