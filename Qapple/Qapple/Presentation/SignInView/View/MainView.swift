//
//  SignInView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/11/24.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private(set) var authViewModel: AuthViewModel
    @StateObject private var pathModel: PathModel = .init()
    
    @State private var isUpdateAlertpresented = false
    
    var body: some View {
        Group {
            if authViewModel.isSignIn {
                MainTabView()
                    .environmentObject(pathModel)
                    .environmentObject(authViewModel)
            } else {
                SignInView()
                    .environmentObject(pathModel)
                    .environmentObject(authViewModel)
                    .onAppear {
                        if authViewModel.isAutoSignInMode {
                            AppleLoginService.shared.autoLogin { isSingIn in
                                if isSingIn {
                                    DispatchQueue.main.async {
                                        authViewModel.isAutoSignInMode = false
                                        authViewModel.isSignIn = true
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        authViewModel.isAutoSignInMode = false
                                        authViewModel.isSignIn = false
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .task {
            let isRecentVersion = await VersionManager.isRecentVersion()
            switch isRecentVersion {
            case .success(let isRecent):
                if !isRecent {
                    isUpdateAlertpresented.toggle()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        .alert("업데이트 알림", isPresented: $isUpdateAlertpresented) {
            HStack {
                Button("취소", role: .cancel) {}
                Button("업데이트", role: .none) {
                    VersionManager.openAppStore()
                }
            }
        } message: {
            Text("캐플이 업데이트되었습니다. 원활한 사용을 위해 업데이트 부탁드립니다!")
        }
    }
}

// MARK: - MainTabView

private struct MainTabView: View {
    
    @State private var tabType: TabType = .questionList
    
    @StateObject private var activePathModel: Router = .init(pathType: .questionList)
    @StateObject var answerViewModel: AnswerViewModel = .init()
    @StateObject private var bulletinBoardUseCase = BulletinBoardUseCase()
    @StateObject private var pushNotificationManager: PushNotificationManager = .shared
    
    var body: some View {
        NavigationStack(path: $activePathModel.route) {
            TabView(selection: $tabType) {
                HomeView()
                    .tag(TabType.questionList)
                    .tabItem {
                        TabItem(
                            systemImage: TabType.questionList.icon,
                            title: TabType.questionList.title
                        )
                    }
                
                BulletinBoardView()
                    .tag(TabType.bulletinBoard)
                    .tabItem {
                        TabItem(
                            systemImage: TabType.bulletinBoard.icon,
                            title: TabType.bulletinBoard.title
                        )
                    }
                
                MyPageView()
                    .tag(TabType.myProfile)
                    .tabItem {
                        TabItem(
                            systemImage: TabType.myProfile.icon,
                            title: TabType.myProfile.title
                        )
                    }
            }
            .tint(BrandPink.button)
            .navigationDestination(for: QuestionListPathType.self) { path in
                activePathModel.getNavigationDestination(
                    answerViewModel: answerViewModel,
                    view: path
                )
            }
            .navigationDestination(for: BulletinBoardPathType.self) { path in
                activePathModel.getNavigationDestination(view: path)
            }
            .navigationDestination(for: MyProfilePathType.self) { path in
                activePathModel.getNavigationDestination(view: path)
            }
        }
        .environmentObject(activePathModel)
        .environmentObject(bulletinBoardUseCase)
        .onChange(of: tabType) { _, tab in
            switch tabType {
            case .questionList: activePathModel.updatePathType(to: .questionList)
            case .bulletinBoard: activePathModel.updatePathType(to: .bulletinBoard)
            case .myProfile: activePathModel.updatePathType(to: .myProfile)
            }
        }
        .onReceive(self.pushNotificationManager.$boardId) { id in
            guard let boardId = id else {
                return
            }
            self.tabType = .bulletinBoard
            
            Task.init {
                let singleBoard = try await NetworkManager.fetchSingleBoard(.init(boardId: boardId))
                
                let post = Post(boardId: singleBoard.boardId, writerId: singleBoard.writerId, writerNickname: singleBoard.writerNickname, content: singleBoard.content, heartCount: singleBoard.heartCount, commentCount: singleBoard.commentCount, createAt: singleBoard.createdAt.ISO8601ToDate, isMine: singleBoard.isMine, isReported: singleBoard.isReported, isLiked: singleBoard.isLiked)
                
                self.activePathModel.pushView(screen: BulletinBoardPathType.comment(post: post))
            }
        }
    }
}

// MARK: - TabItem

private struct TabItem: View {
    
    let systemImage: String
    let title: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: 32, height: 32)
            
            Text(title)
                .pretendard(.medium, 12)
        }
    }
}

// MARK: - 홈 뷰
private struct HomeView: View {
    
    @EnvironmentObject var pathModel: Router
    @StateObject var authViewModel: AuthViewModel = .init()
    @StateObject var answerViewModel: AnswerViewModel = .init()
    
    @State private var tab: TodayQuestionTab = .todayQuestion
    
    var body: some View {
        VStack(spacing: 0) {
            CustomTabBar(tab: $tab)
            
            TabView(selection: $tab) {
                TodayQuestionView()
                    .tag(TodayQuestionTab.todayQuestion)
                
                TodayQuestionListView()
                    .tag(TodayQuestionTab.questionList)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            NotificationManager.shared.requestNotificationPermission()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: tab) { _, _ in
            HapticManager.shared.impact(style: .light)
        }
    }
}

// MARK: - 로그인 뷰
private struct SignInView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var clickedLoginButton = false
    
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
                            
                        case .terms:
                            SignUpServiceTermsView()
                            
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
                
                // 자동 로그인 실행 전 화면
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(authViewModel.isAutoSignInMode ? Background.first : .clear)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
        }
        .onChange(of: authViewModel.isSignUp) { _, isSignUp in
            if isSignUp {
                pathModel.paths.append(.email)
            }
        }
        .alert("일시적인 오류로 애플 로그인에 실패했습니다. 다시 시도해주세요.", isPresented: $authViewModel.isAppleLoginFailedAlertPresenteed) {
            Button("확인", role: .none) {}
        }
        .alert("캐플 서버 로그인에 실패했습니다. 관리자에게 문의해주세요.", isPresented: $authViewModel.isSignInFailedAlertPresented) {
            Button("확인", role: .none) {}
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
    
    @EnvironmentObject var pathModel: Router
    @Binding var tab: TodayQuestionTab
    
    private var backgroundColor: Color {
        switch tab {
        case .todayQuestion: return Background.second
        case .questionList: return Background.first
        }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 28) {
                Spacer()
                
                // 오늘의질문
                Button {
                    tab = .todayQuestion
                } label: {
                    Text("오늘의 질문")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(tab == .todayQuestion ? TextLabel.main : TextLabel.sub4)
                }
                
                // 질문리스트
                Button {
                    tab = .questionList
                } label: {
                    Text("질문 리스트")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(tab == .questionList ? TextLabel.main : TextLabel.sub4)
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Button {
                    pathModel.pushView(screen: QuestionListPathType.notifications)
                } label: {
                    Image(.noticeIcon)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .frame(width: 24 , height: 24)
                }
            }
            .padding(.trailing, 16)
        }
        .frame(height: 32)
        .background(backgroundColor)
    }
}

#Preview {
    MainView(authViewModel: .init())
}
