//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI
struct TodayAnswerView: View {
    
    @ObservedObject var viewModel = TodayAnswersViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationView()
            KeywordScrollView(viewModel: viewModel)
            Spacer()
                .frame(height: 16)
            FloatingQuestionCard(viewModel: viewModel)
            
            Spacer()
                .frame(height: 32)

            AnswerScrollView(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden()
        .background(Color.Background.first)
    }
}

// MARK: - 커스텀 네비게이션
private struct CustomNavigationView: View {
    var body: some View {
        CustomNavigationBar(
            leadingView:{
                CustomNavigationBackButton(buttonType: .arrow)
            },
            principalView: {
                Text("오늘의 답변")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
                Button {
                    // TODO: 답변 검색화면 이동
                } label: {
                    Image(.search)
                }
            },
            backgroundColor: .clear
        )
    }
}

// MARK: - 키워드 스크롤 뷰
private struct KeywordScrollView: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.keywords, id: \.self) { keyword in
                    KeywordSelector(
                        keywordText: keyword,
                        keywordCount: 13) {
                            // TODO: 키워드 선택
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 플로팅 질문 카드
private struct FloatingQuestionCard: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isCardExpanded = true
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        HStack {
            Text(viewModel.todayQuestionText)
                .font(.pretendard(.semiBold, size: 15))
                .foregroundStyle(TextLabel.main)
                .lineLimit(isCardExpanded ? 3 : 0)
            
            Spacer() // 화살표를 오른쪽으로 밀어내기 위해 Spacer 추가
            
            Button {
                withAnimation {
                    isCardExpanded.toggle() // 버튼 클릭 시 카드 확장/축소 상태 토글
                }
            } label: {
                Image(isCardExpanded ? .arrowUp : .arrowDown)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(GrayScale.secondaryButton)
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
    
}

// MARK: - 답변 스크롤 뷰
private struct AnswerScrollView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isBottomSheetPresented = false
    let cardHeight: CGFloat = 150 // 답변 카드의 높이를 정의합니다.
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack {
                
                ForEach(Array(viewModel.answers.enumerated()), id: \.offset) { index, answer in
                    VStack(spacing: 24) {
                        
                        AnswerCell(
                            profileName: answer.nickname ?? "닉네임",
                            answer: answer.content ?? "콘텐츠",
                            keywords: viewModel.keywords,
                            seeMoreAction: {
                                isBottomSheetPresented.toggle()
                            }
                        )
                        .padding(.horizontal, 24)
                        .sheet(isPresented: $isBottomSheetPresented) {
                            SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                .presentationDetents([.height(84)])
                        }
                        
                        Separator()
                            .padding(.leading, 24)
                    }
                    .padding(.bottom, 16)
                }
                

                // MARK: - 기존 현희 누나 코드
//                ForEach(Array(viewModel.answers.enumerated()), id:\.offset) { index, answer in
//                    GeometryReader { geometry in
//                        let frame = geometry.frame(in: .global)
//                        let midY = frame.midY
//                        let screenHeight = UIScreen.main.bounds.height
//                        let scale = min(1.0, 1 - abs(midY - screenHeight / 2) / (screenHeight / 2))
//                        SingleAnswerView(answer: answer)
//                            .scaleEffect(scale) // 중앙에 위치할수록 더 크게 표시
//                            .frame(height: self.cardHeight)
//                            .padding()
//                            .onAppear {
//                                viewModel.loadMoreContentIfNeeded(currentIndex: index)
//                            }
//                    }
//                }
//                .frame(height: self.cardHeight) // GeometryReader에도 높이 설정

                // 로딩 화면
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

#Preview {
    TodayAnswerView()
}
