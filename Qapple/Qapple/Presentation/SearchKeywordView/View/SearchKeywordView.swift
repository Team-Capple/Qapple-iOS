//
//  SearchKeywordView.swift
//  Capple
//
//  Created by 김민준 on 2/26/24.
//

import SwiftUI

struct SearchKeywordView: View {
    
    enum SearchState {
        case initial // 초기 상태
        case none // 검색 결과 없음
        case result // 검색 결과 있음
    }
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: AnswerViewModel
    
    @State private var searchState: SearchState = .initial
    @State private var alignment: HorizontalAlignment = .leading
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(alignment: searchState == .initial ? .leading : .center) {
                
                CustomNavigationBar(
                    leadingView: {
                        CustomNavigationBackButton(buttonType: .arrow) {
                            pathModel.paths.removeLast()
                        }
                    },
                    principalView: {
                        TextField(text: $viewModel.search) {
                            Text(viewModel.search.isEmpty ? "키워드 검색" : "")
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundStyle(TextLabel.placeholder)
                        }
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(.wh)
                        .padding(.leading, 36)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            searchState = .none
                        }
                    },
                    trailingView: {},
                    backgroundColor: .clear
                )
                
                Separator()
                Spacer()
                VStack {
                    
                    // 초기 상태
                    if searchState == .initial || viewModel.search.isEmpty {
                        InitialView(viewModel: viewModel)
                    }
                    
                    // 검색 결과 없음
                    else if searchState == .none {
                        NoneView(viewModel: viewModel)
                    }
                    
                    // 검색 결과 표시
                    else if searchState == .result {
                        ResultView(viewModel: viewModel)
                    }
                }
            }
            .background(Background.second)
            .onTapGesture {
                isTextFieldFocused = false
            }
            .navigationBarBackButtonHidden()
            .onDisappear {
                viewModel.search = ""
            }
        }
    }
}

// MARK: - InitialView
private struct InitialView: View {
    
    @ObservedObject var viewModel: AnswerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.keywordPreviews, id: \.self) { keyword in
                    Button {
                        viewModel.addKeyword(keyword)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(keyword.name)
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(TextLabel.sub1)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 24)
        }
        
        Spacer()
    }
}

// MARK: - NoneView
private struct NoneView: View {
    
    @ObservedObject var viewModel: AnswerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("'\(viewModel.search)'")
                .font(.pretendard(.bold, size: 18))
                .foregroundStyle(TextLabel.main)
            
            Spacer()
                .frame(height: 12)
            
            Text("키워드는 아직 등록되지 않았어요")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub3)
            
            Spacer()
                .frame(height: 24)
            
            KeywordChoiceChip(buttonType: .addKeyword) {
                // viewModel.createNewKeyword()
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
        }
    }
}

// MARK: - ResultView
private struct ResultView: View {
    
    @ObservedObject var viewModel: AnswerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // TODO: - 네트워킹 검색 결과 출력
                ForEach(viewModel.keywordPreviews, id: \.self) { keyword in
                    Button {
                        viewModel.addKeyword(keyword)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(keyword.name)
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(TextLabel.sub1)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.leading, 24)
            }
            .padding(.top, 24)
        }
        
        Spacer()
    }
}

#Preview {
    SearchKeywordView(viewModel: .init())
}
