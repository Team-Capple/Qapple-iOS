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
                        HStack(spacing: 28) {
                            Button {
                                HapticManager.shared.impact(style: .soft)
                                tab = .answering
                            } label: {
                                Text("오늘의질문")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.sub4)
                            }
                            Button {
                                HapticManager.shared.impact(style: .soft)
                                tab = .collecting
                            } label: {
                                Text("질문리스트")
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
                                .frame(width: 32 , height: 32)
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
            Task {
                await viewModel.fetchGetQuestions()
            }
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
                
                Text("지금까지의 질문을\n모아뒀어요")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(TextLabel.main)
                    .padding(.horizontal, 24)
                    .lineSpacing(6)
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
                                QuestionView(question: question, tab: $tab, questionNumber: viewModel.questions.count - index) {
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
                                .alert("답변하면 확인이 가능해요 😀", isPresented: $isAnsweredAlert) {
                                    Button("확인", role: .none) {}
                                } message: {
                                    Text("즐거운 커뮤니티 운영을 위해\n여러분의 답변을 들려주세요")
                                }
                                .padding(.horizontal, 24)
                                .sheet(isPresented: $isBottomSheetPresented) {
                                    SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                        .presentationDetents([.height(84)])
                                    
                                }
                                Separator()
                                    .padding(.leading, 24)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    Task {
                        await viewModel.fetchGetQuestions()
                    }
                }
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    SearchResultView(tab: .constant(.collecting))
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
