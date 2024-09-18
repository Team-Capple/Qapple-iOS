import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct TodayQuestionListView: View {
    
    @EnvironmentObject var pathModel: Router
    @StateObject var viewModel: QuestionViewModel = .init()
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(Background.first)
                .edgesIgnoringSafeArea(.all) // 전체 배경색을 검정색으로 설정합니다.
            
            VStack(spacing: 0) {
                
                QuestionListView(viewModel: viewModel, isBottomSheetPresented: $isBottomSheetPresented)
                
                Spacer()
                    .frame(height: 0)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchGetQuestions()
            }
        }
    }
    
    // MARK: - QuestionListView
    private struct QuestionListView: View {
        
        @EnvironmentObject var pathModel: Router
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
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                    Spacer()
                    
                }
                .padding(.horizontal, 24)
                
                ScrollView {
                    LazyVStack(spacing: 4) {
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
                                    let id = question.questionId
                                    
                                    // 만약 답변 안했다면 경고 창 띄우기
                                    if !question.isAnswered {
                                        isAnsweredAlert.toggle()
                                        HapticManager.shared.notification(type: .warning)
                                        return
                                    }
                                    
                                    pathModel.pushView(
                                        screen: QuestionListPathType.todayAnswer(
                                            questionId: id, questionContent: viewModel.contentForQuestion(
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
                                .padding(.init(top: 0, leading: 12, bottom: 6, trailing: 10))
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
    TodayQuestionListView()
        .environmentObject(Router(pathType: .questionList))
        .environmentObject(AuthViewModel())
}
