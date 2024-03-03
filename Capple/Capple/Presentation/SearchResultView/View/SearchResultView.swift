import SwiftUI

// 질문 목록을 보여주는 뷰를 정의합니다.
struct SearchResultView: View {
    @ObservedObject var viewModel: QuestionViewModel // 뷰 모델을 관찰합니다.
    @State private var searchText = "" // 사용자 검색 텍스트를 저장합니다.
    @State private var isTextEditing = false
    // 뷰 모델을 초기화하는 생성자입니다.
    init(viewModel: QuestionViewModel = QuestionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // 전체 배경색을 검정색으로 설정합니다.
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.filteredQuestions) { question in
                            QuestionView(question: question) // 각 질문에 대한 뷰를 생성합니다.
                                .onAppear {
                                    viewModel.loadMoreContentIfNeeded(currentItem: question) // 필요한 경우 더 많은 내용을 로드합니다.
                                }
                                .padding(.vertical, 8) // 질문 사이의 수직 패딩을 추가합니다.
                                .background(Color.black) // 각 질문의 배경색을 검정색으로 설정합니다.
                        }
                        if viewModel.isLoading { // 로딩 중인 경우 로딩 인디케이터를 표시합니다.
                            ProgressView()
                                .scaleEffect(1.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                    
                }
                .refreshable {
                    searchText = "" // 검색 텍스트 초기화
                    viewModel.reloadQuestions() // ViewModel에서 원래 목록을 다시 로드하는 메서드를 호출합니다.
                }
                .navigationTitle("질문모아보기") // 네비게이션 바의 제목을 설정합니다.
                .navigationBarTitleDisplayMode(.inline)
            }
        }
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
    }
    
    
    // 이 뷰의 프리뷰를 제공하는 구조체입니다.
    struct SearchResultView_Previews: PreviewProvider {
        static var previews: some View {
            SearchResultView() // SearchResultView의 프리뷰를 생성합니다.
        }
    }
}
