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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: AnswerViewModel
    
    @State private var searchState: SearchState = .initial
    @State private var alignment: HorizontalAlignment = .leading
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(Background.second)
                    .ignoresSafeArea()
                
                VStack(alignment: searchState == .initial ? .leading : .center) {
                    Separator()
                    Spacer()
                    VStack {
                        
                        // 초기 상태
                        if searchState == .initial || viewModel.search.isEmpty {
                            InitialView()
                                .environmentObject(viewModel)
                        }
                        
                        // 검색 결과 없음
                        else if searchState == .none {
                            NoneView()
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.wh)
                            .frame(width: 32, height: 32)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    
                    TextField(text: $viewModel.search) {
                        Text(viewModel.search.isEmpty ? "키워드 검색" : "")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundStyle(TextLabel.placeholder)
                    }
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(.wh)
                    .padding(.leading, -8)
                    .focused($isTextFieldFocused)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: - 검색하기
                        searchState = .none
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.wh)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

// MARK: - InitialView
private struct InitialView: View {
    
    @EnvironmentObject var viewModel: AnswerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 28)
            
            ForEach(viewModel.keywordPreviews, id: \.self) { keyword in
                Button {
                    // TODO: - 키워드 적용하기
                    viewModel.keywords.append(.init(name: "테스트"))
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(keyword.name)
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.sub1)
                }
                .padding(.bottom, 24)
            }
            .padding(.leading, 24)
            
            Spacer()
        }
    }
}

// MARK: - NoneView
private struct NoneView: View {
    
    @EnvironmentObject var viewModel: AnswerViewModel
    
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
                // TODO: - 키워드 추가 액션
            }
            
            Spacer()
        }
    }
}

#Preview {
    SearchKeywordView(viewModel: .init())
        .environmentObject(AnswerViewModel())
}
