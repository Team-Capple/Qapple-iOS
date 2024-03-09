import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct SearchResultView: View {
    
    @StateObject var viewModel: QuestionViewModel = .init() // 뷰 모델을 관찰합니다.
    @Binding var topTab: TopTab
    @State private var searchText = "" // 사용자 검색 텍스트를 저장합니다.
    // @State private var isTextEditing = false
    @State private var isBottomSheetPresented = false
    @State private var isAnswerViewPresented = false
    @State private var isAlertViewPresented = false
    @State private var isReportViewPresented = false
    @State private var isTodayAnswerViewPresented = false
    
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
                                topTab = .answering
                            } label: {
                                Text("답변하기")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.sub4)
                            }
                            Button {
                                // TODO: - 모아보기 리프레시
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
                        HStack(spacing: 8) {
                            Button {
                                isAlertViewPresented.toggle()
                            } label: {
                                Image(.noticeIcon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24 , height: 24)
                            }
                            
                            NavigationLink(destination: MyPageView()) {
                                Image(.capple)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24 , height: 24)
                            }
                        }
                    },
                    backgroundColor: Background.first)
                
                HeaderView(viewModel: viewModel)
                
                Spacer()
                    .frame(height: 0)
                
                QuestionListView(
                    viewModel: viewModel,
                    isBottomSheetPresented: $isBottomSheetPresented,
                    isReportViewPresented: $isReportViewPresented,
                    isTodayAnswerViewPresented: $isTodayAnswerViewPresented, isAnswerViewPresented: $isAnswerViewPresented
                )
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isAlertViewPresented) {
            AlertView()
        }
        .navigationDestination(isPresented: $isReportViewPresented) {
            ReportView()
        }
        .navigationDestination(isPresented: $isTodayAnswerViewPresented) {
            TodayAnswerView()
        }
        .navigationDestination(isPresented: $isAnswerViewPresented) {
            AnswerView()
        }
        
        
        // MARK: - 필터링(서칭)기능
        /*
         .searchable(text: $searchText, prompt: "검색어를 입력하세요") // 검색 기능을 추가합니다.
         .foregroundColor(isTextEditing ? .white : .black)
        .onChange(of: searchText) {
            /* newValue, oldValue in
             viewModel.searchQuery = newValue // 사용자가 검색 텍스트를 변경할 때마다 뷰 모델의 검색 쿼리를 업데이트합니다.
             */
            isTextEditing = true
            
        }
        .onSubmit(of: .search) {
            isTextEditing = true
            viewModel.filterQuestions(with: searchText)
        }
        .navigationTitle("질문목록") // 네비게이션 바의 두 번째 제목을 설정합니다.
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // 이 버튼을 클릭하면 검색 상태를 초기화
                    searchText = ""
                    viewModel.reloadQuestions() // 여기서 'reloadQuestions'는 모든 질문을 다시 로드하는 메서드입니다.
                }) {
                    Image(systemName: "arrow.clockwise") // 새로고침 아이콘
                }
                Button(action: {
                    
                }) {
                    Image(systemName: "magnifyingglass") // 돋보기 아이콘을 표시합니다.
                }
            }
        }
         */
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
    
    @ObservedObject private var viewModel: QuestionViewModel
    @Binding var isBottomSheetPresented: Bool
    @Binding var isReportViewPresented: Bool
    @Binding var isTodayAnswerViewPresented: Bool
    @Binding var isAnswerViewPresented: Bool
    
    fileprivate init(
        viewModel: QuestionViewModel,
        isBottomSheetPresented: Binding<Bool>,
        isReportViewPresented: Binding<Bool>,
        isTodayAnswerViewPresented: Binding<Bool>,
        isAnswerViewPresented: Binding<Bool>
    ) {
        self.viewModel = viewModel
        self._isBottomSheetPresented = isBottomSheetPresented
        self._isReportViewPresented = isReportViewPresented
        self._isTodayAnswerViewPresented = isTodayAnswerViewPresented
        self._isAnswerViewPresented = isAnswerViewPresented
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(alignment: .center) {
                Text("\(viewModel.questions.count)개의 질문")
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.sub3)
                
                Spacer()
                
                Button {
                    // TODO: 최신순/인기순 필터
                } label: {
                    Text("최신순")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(BrandPink.text)
                }
                
                Spacer()
                    .frame(width: 12)
                
                Button {
                 // TODO: 검색 화면 이동
                } label: {
                    Image(.search)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 12)
            
            Separator()
            
            ScrollView {
                LazyVStack {
                    ForEach(Array(viewModel.questions.enumerated()), id: \.offset) { index, question in
                        VStack(spacing: 24) {
                            QuestionView(questions: question, seeMoreAction: {},
                                         isTodayAnswerViewPresented:  $isTodayAnswerViewPresented, isAnswerViewPresented: $isAnswerViewPresented)
                            .padding(.horizontal, 24)
                            .sheet(isPresented: $isBottomSheetPresented) {
                                SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented, isReportViewPresented: $isReportViewPresented)
                                    .presentationDetents([.height(84)])
                            }
                            Spacer()
                                .frame(height: 16)
                            
                            Separator()
                                .padding(.leading, 24)
                        }
                        .padding(.bottom, 24)
                    }
                       }
                
            }
            .padding(.top, 24)
            .scrollIndicators(.hidden)
            .refreshable {
                // searchText = "" // 검색 텍스트 초기화
                viewModel.reloadQuestions() // ViewModel에서 원래 목록을 다시 로드하는 메서드를 호출합니다.
            }
        }
    }
}


#Preview {
    SearchResultView(topTab: .constant(.collecting))
}
