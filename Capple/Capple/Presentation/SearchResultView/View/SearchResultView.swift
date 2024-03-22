import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct SearchResultView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: QuestionViewModel = .init()
    @Binding var tab: Tab
    @State private var isBottomSheetPresented = false
    
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
        .onAppear {
            viewModel.getQuestions()
        }
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
        
        @State private var isAnsweredAlert = false
        
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
                                QuestionView(questions: question, tab: $tab, questionNumber: viewModel.questions.count - index) {
                                    isBottomSheetPresented.toggle()
                                }
                                .onTapGesture {
                                    guard let id = question.questionId else { return }
                                    
                                    // 만약 답변 안했다면 경고 창 띄우기
                                    if !question.isAnswered {
                                        isAnsweredAlert.toggle()
                                        return
                                    }
                                    
                                    pathModel.paths.append(
                                        .todayAnswer(
                                            questionId: id,
                                            questionContent: viewModel.contentForQuestion(
                                                withId: id
                                            ) ?? "내용 없음"
                                        )
                                    )
                                }
                                .alert("답변을 먼저 해야 볼 수 있어요", isPresented: $isAnsweredAlert) {
                                    Button("확인", role: .none, action: {})
                                }
                            }
                            
                            .padding(.horizontal, 24)
                            .sheet(isPresented: $isBottomSheetPresented) {
                                SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                    .presentationDetents([.height(84)])
                            }
                            
                            Separator()
                                .padding(.leading, 24)
                        }
                        .padding(.bottom, 0)
                        
                        Spacer()
                            .frame(height: 32)
                    }
                }
            }
            
            .padding(.top, 24)
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.getQuestions()
            }
        }
    }
}

#Preview {
    SearchResultView(viewModel: .init(), tab: .constant(.collecting))
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
