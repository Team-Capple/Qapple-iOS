//
//  SearchResultView.swift
//  Capple
//
//  Created by 심현희 Lee on 2/23/24.
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @State private var searchText = ""
    init(viewModel: QuestionViewModel = QuestionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.filteredQuestions) { question in // 필터링된 질문들을 사용합니다.
                            QuestionView(question: question)
                                .onAppear {
                                    viewModel.loadMoreContentIfNeeded(currentItem: question)
                                }
                                .padding(.vertical, 8)
                                .background(Color.black)
                        }
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                }
                .navigationTitle("질문모아보기")
                .navigationBarTitleDisplayMode(.inline)
            }
        }.searchable(text: $searchText, prompt: "검색어를 입력하세요")
        
            .onChange(of: searchText) { newValue in
                viewModel.searchQuery = newValue // '$'를 제거합니다.
            }
        
            .navigationTitle("질문목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 검색 기능이 활성화되는 로직
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}


