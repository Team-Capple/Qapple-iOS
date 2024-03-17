import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct SearchResultView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: QuestionViewModel
    @Binding var tab: Tab
    @State private var searchText = "" // 사용자 검색 텍스트를 저장합니다.
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        
        NavigationStack {
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
                        .environmentObject(pathModel)
                    
                    Spacer()
                        .frame(height: 0)
                    
                    
                }
                .navigationDestination(for: PathType.self) {  pathType in
                    switch pathType {
                      case .todayAnswer(let questionId):
                          TodayAnswerView(questionId: questionId, tab: $tab)
                      // 다른 경로에 대한 뷰를 여기 추가...
                      default:
                          EmptyView() 
                      }
                         
                }
                /*
                .navigationDestination(for: Int.self) { questionId in
                    TodayAnswerView(questionId: questionId, tab: $tab)
                }
                */
            }
            .navigationBarBackButtonHidden()
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
            .frame(height: 120)
        }
    }
    
    
    // MARK: - QuestionListView
    private struct QuestionListView: View {
        @EnvironmentObject var authViewModel: AuthViewModel // AuthViewModel 주입
        @EnvironmentObject var pathModel: PathModel
        @ObservedObject private var viewModel: QuestionViewModel
        @Binding var isBottomSheetPresented: Bool
        @Binding var tab: Tab
        
        fileprivate init(
            viewModel: QuestionViewModel, tab: Binding<Tab>,
            isBottomSheetPresented: Binding<Bool>
        ) {
            self.viewModel = viewModel
            self._isBottomSheetPresented = isBottomSheetPresented
            self._tab = tab
            
        }
       
        
        var body: some View {
            
            VStack(spacing: 0) {
                
                HStack(alignment: .center) {
                    Text("\(viewModel.questions.count)개의 질문")
                        .font(.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.sub3)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 12)
                
                Separator()
                
                ScrollView {
                    LazyVStack {
                        ForEach(Array(viewModel.questions.enumerated()), id: \.offset) { index, question in
                            VStack(spacing: 20) {
                                /*
                                Button(action: {
                                  pathModel.paths.append(.todayAnswer(question.questionId ?? 1))
                                    print("this is question", question)
                                    print("this is questionID maybe...",question.questionId ?? "default value")
                                    isBottomSheetPresented.toggle()
                                })
                                 */
                                //{
                                NavigationLink(destination: TodayAnswerView(questionId: question.questionId ?? 1, tab: $tab)) {
                                    QuestionView(tab: $tab, questions: question) {
                                        print("this is question", question)
                                        print("this is questionID maybe...",question.questionId ?? "default value")
                                        isBottomSheetPresented.toggle()
                                    }
                                }
                                /*
                                     NavigationLink(destination: TodayAnswerView(questionId: question.questionId ?? 1, tab: $tab)) {
                                         QuestionView(questions: question) {
                                             // 액션 정의
                                             pathModel.paths.append(.todayAnswer(question.questionId ?? 1))
                                             print("this is question", question)
                                             print("this is questionID maybe...",question.questionId ?? "default value")
                                             isBottomSheetPresented.toggle()
                                         }
                                 */
                                
                                     /*
                                        QuestionView(questions: question) {
                                            // 액션 정의
                                            pathModel.paths.append(.todayAnswer(question.questionId ?? 1))
                                            print("this is question", question)
                                            print("this is questionID maybe...",question.questionId ?? "default value")
                                            isBottomSheetPresented.toggle()
                                            isBottomSheetPresented.toggle()
                                        }
                                    */
                                   
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
                        }
                    }
                    
                }
                .padding(.top, 24)
                .scrollIndicators(.hidden)
                .refreshable {
                    // searchText = "" // 검색 텍스트 초기화
                    viewModel.updateQuestions(using: AuthViewModel() ) // ViewModel에서 원래 목록을 다시 로드하는 메서드를 호출합니다.
                }
            }
        }
    }
    

/*
#Preview {
    SearchResultView(topTab: .constant(.collecting))
}
*/
