import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct SearchResultView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: QuestionViewModel
    @Binding var tab: Tab
    @State private var searchText = "" // 사용자 검색 텍스트를 저장합니다.
    @State private var isBottomSheetPresented = false
    let accessToken = SignInInfo.shared.accessToken()
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .edgesIgnoringSafeArea(.all) // 전체 배경색을 검정색으로 설정합니다.
            
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leadingView: { },
                    principalView: {
                        HStack(spacing: 20) {
                            Button {
                                tab = .answering
                            } label: {
                                Text("답변하기")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.sub4)
                            }
                            Button {
                                tab = .collecting
                            } label: {
                                Text("모아보기")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.main)
                            }
                        }
                        .font(Font.pretendard(.semiBold, size: 14))
                        .foregroundStyle(TextLabel.sub4)
                    },
                    trailingView: {
                        Button {
                            pathModel.paths.append(.myPage)
                            
                        } label: {
                            Image(.capple)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24 , height: 24)
                        }
                    },
                    backgroundColor: Background.first)
                
                HeaderView(viewModel: viewModel)
                
                QuestionListView(viewModel: viewModel, tab: $tab, isBottomSheetPresented: $isBottomSheetPresented)
                
                Spacer()
                    .frame(height: 0)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - HeaderView
    private struct HeaderView: View {
        
        @ObservedObject private var viewModel: QuestionViewModel
        
        fileprivate init(viewModel: QuestionViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            ZStack(alignment: .leading) {
                Color(Background.first)
                
                Text("여러분이 작성한\n답변을 모아뒀어요")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(TextLabel.main)
                    .padding(.horizontal, 24)
            }
            .frame(height: 100)
        }
    }
    
    // MARK: - QuestionListView
    private struct QuestionListView: View {
        
        @EnvironmentObject var pathModel: PathModel
        @ObservedObject private var viewModel: QuestionViewModel
        @Binding var isBottomSheetPresented: Bool
        @Binding var tab: Tab
        public var todayQuestionTitle: String = ""
        let accessToken = SignInInfo.shared.accessToken()
        
        fileprivate init(
            viewModel: QuestionViewModel, tab: Binding<Tab>,
            isBottomSheetPresented: Binding<Bool>
        ) {
            self.viewModel = viewModel
            self._isBottomSheetPresented = isBottomSheetPresented
            self._tab = tab
            
        }
        
        var body: some View {
            
            VStack(spacing: 20) {
                
                HStack(alignment: .top) {
                    Text("\(viewModel.questions.count)개의 질문")
                        .font(.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.sub3)
                    Spacer()
                    
                }
                .padding(.horizontal, 24)
                
                Separator()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(Array(viewModel.questions.enumerated()), id: \.offset) { index, question in
                            VStack(spacing: 20) {
                                QuestionView(tab: $tab, questions: question){
                                    isBottomSheetPresented.toggle()
                                }
                                .onTapGesture {
                                    guard let id = question.questionId else { return }
                                    pathModel.paths.append(.todayAnswer(questionId: id, questionContent: viewModel.contentForQuestion(withId: id) ?? "내용 없음"))
                                }
                                // TODO: alert 붙이기 / 답변안했을 경우
                            }
                            
                            .padding(.horizontal, 24)
                            .sheet(isPresented: $isBottomSheetPresented) {
                                SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                    .presentationDetents([.height(84)])
                            }
                            
                            Separator()
                                .padding(.leading, 24)
                        }
                        .padding(.bottom, 20)
                        Spacer()
                            .frame(height: 32)
                    }
                }
            }
            
            .padding(.top, 24)
            .scrollIndicators(.hidden)
            .refreshable {
                // ViewModel에서 원래 목록을 다시 로드하는 메서드를 호출합니다.
                viewModel.getQuestions(accessToken: accessToken )
            }
        }
    }
}

#Preview {
    SearchResultView(viewModel: .init(), tab: .constant(.collecting))
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
