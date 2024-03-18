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
                        .environmentObject(pathModel)
                    
                    Spacer()
                        .frame(height: 0)
                    
                    
                }
            }
        
            /*
            .navigationDestination(for: PathType.self) {  pathType in
                switch pathType {
                  case .todayAnswer(let questionId, let questionContent):
                    TodayAnswerView(questionId: questionId, tab: $tab, questionContent: questionContent)
                  default:
                      EmptyView()
                  }
                     
            }
             */
            .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getQuestions(accessToken: accessToken)
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
                                QuestionView(tab: $tab, questions: question){
                                     isBottomSheetPresented.toggle()
                                }
                                .onTapGesture {
                                   guard let id = question.questionId else { return }
                                    pathModel.paths.append(.todayAnswer(questionId: id, questionContent: viewModel.contentForQuestion(withId: id) ?? "내용 없음"))
                                    QuestionService.shared.questionId = id
                               
                                }
                                
                                // MARK: - 확인용코드
                                /*
                                Button (action: {
                                    print(question.questionId ?? 1234566)
                                }, label: {
                                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                                })
                                */
                                /*
                                
                                Button(action: {
                                  pathModel.paths.append(.todayAnswer(question.questionId ?? 1))
                                    print("this is question", question)
                                    print("this is questionID maybe...",question.questionId ?? "default value")
                                    isBottomSheetPresented.toggle()
                                })
                                 */
                                //{
                                
                                /*
                                NavigationLink(destination: TodayAnswerView(questionId: question.questionId ?? 1, tab: $tab,questionContent: viewModel.contentForQuestion(withId: question.questionId ?? 1) ?? "내용 없음")) {
                                    QuestionView(tab: $tab, questions: question) {
                                       
                                        print("this is question", question)
                                        print("this is questionID maybe...",question.questionId ?? "default value")
                                        isBottomSheetPresented.toggle()
                                    }
                                }
                                 */
                                
                                
                                
                                // pathModel.paths.append(.todayAnswer(questionId: question.questionId, questionContent: viewModel.contentForQuestion(withId: question.questionId) ?? "네비게이션링크에서 디폴트 스트링 입니다"))
                                
                                
                               /*
                                NavigationLink(destination: TodayAnswerView(
                                    questionId: question.questionId,
                                    tab: $tab,
                                    questionContent: viewModel.contentForQuestion(withId: question.questionId) ?? "네비게이션링크에서 디폴트 스트링 입니다"
                                )) {
                                   QuestionView(tab: $tab, questions: question){
                                        isBottomSheetPresented.toggle()
                                      
                                   }.onAppear {
                                       viewModel.getQuestions(accessToken: accessToken)
                                   }
                                }
                                 */
                               
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
                    viewModel.getQuestions(accessToken: accessToken ) // ViewModel에서 원래 목록을 다시 로드하는 메서드를 호출합니다.
                }
            }
        }
    }
    

/*
#Preview {
    SearchResultView(topTab: .constant(.collecting))
}
*/
