import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct SearchResultView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: QuestionViewModel = .init()
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(Background.first)
                .edgesIgnoringSafeArea(.all) // 전체 배경색을 검정색으로 설정합니다.
            
            VStack(spacing: 0) {
                HeaderView(viewModel: viewModel)
                
                QuestionListView(viewModel: viewModel, isBottomSheetPresented: $isBottomSheetPresented)
                
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
            HStack {
                Text("지금까지의 질문과\n답변을 모아뒀어요")
                    .font(.pretendard(.bold, size: 24))
                    .foregroundStyle(TextLabel.main)
                    .padding(.horizontal, 24)
                    .lineSpacing(6)
                    .frame(height: 120)
                
                Spacer()
            }
            .background(Background.first)
        }
    }
    
    // MARK: - QuestionListView
    private struct QuestionListView: View {
        
        @EnvironmentObject var pathModel: PathModel
        @ObservedObject private var viewModel: QuestionViewModel
        @Binding var isBottomSheetPresented: Bool
        
        @State private var isAnsweredAlert = false
        
        fileprivate init(
            viewModel: QuestionViewModel,
            isBottomSheetPresented: Binding<Bool>
        ) {
            self.viewModel = viewModel
            self._isBottomSheetPresented = isBottomSheetPresented
        }
        
        var body: some View {
            
            VStack(spacing: 11) {
                
                HStack(alignment: .top) {
                    Text("\(viewModel.questions.count)개의 질문")
                        .font(.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.sub3)
                    Spacer()
                    
                }
                .padding(.horizontal, 24)
                
                // Separator()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(Array(viewModel.questions.enumerated()), id: \.offset) {
                            index,
                            question in
                            VStack {
                                QuestionCell(
                                    question: question,
                                    questionNumber: viewModel.questions.count - index
                                ) {
                                    isBottomSheetPresented.toggle()
                                }
                                .onTapGesture {
                                    guard let id = question.questionId else { return }
                                    
                                    // 만약 답변 안했다면 경고 창 띄우기
                                    if !question.isAnswered {
                                        isAnsweredAlert.toggle()
                                        HapticManager.shared.notification(type: .warning)
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
                                .padding(.leading, 24)
                                .padding(.trailing, question.questionStatus == .live ? 0 : 24)
                                
                                if question.questionStatus != .live {
                                    Separator()
                                        .padding(.leading, 24)
                                        .padding(.top, 20)
                                }
                                
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    Task {
                        await viewModel.fetchGetQuestions()
                        HapticManager.shared.impact(style: .light)
                    }
                }
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    SearchResultView()
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
