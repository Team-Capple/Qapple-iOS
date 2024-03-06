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
            FloatingQuestionCard(viewModel: viewModel)
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
    
    
    
    
    // MARK: - 키워드 스크롤 뷰
    private struct KeywordScrollView: View {
        
        @ObservedObject var viewModel: TodayAnswersViewModel
        
        fileprivate init(viewModel: TodayAnswersViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.keywords, id: \.self) { keyword in
                        Text(keyword)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.Background.second)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
        }
        
    }
}// MARK: - 플로팅 질문 카드
private struct FloatingQuestionCard: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isCardExpanded = true
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if isCardExpanded { // 카드가 확장되어 있는 경우에만 내용을 보여줍니다.
            HStack {
                Text(viewModel.todayQuestionText)
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
                    .padding(.leading, 12)
                
                Spacer() // 화살표를 오른쪽으로 밀어내기 위해 Spacer 추가
                
                Button(action: {
                    withAnimation {
                        isCardExpanded.toggle() // 버튼 클릭 시 카드 확장/축소 상태 토글
                    }
                }) {
                    Image(systemName: "chevron.up") // 위쪽 화살표 아이콘 추가
                        .foregroundColor(.white)
                }
                .padding(.trailing, 5)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.Background.second)
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
            .padding(.horizontal)
            .padding(.top, 20)
        } else { // 카드가 축소되어 있는 경우, 확장 버튼만 보여줍니다.
            Button(action: {
                withAnimation {
                    isCardExpanded.toggle() // 버튼 클릭 시 카드 확장/축소 상태 토글
                }
            }) {
                Image(systemName: "chevron.down") // 아래쪽 화살표 아이콘으로 변경
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.Background.second)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
            }
        }
        
    }
    
}

// MARK: - 답변 스크롤 뷰
private struct AnswerScrollView: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    let cardHeight: CGFloat = 150 // 답변 카드의 높이를 정의합니다.
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack {
                ForEach(Array(viewModel.answers.enumerated()), id:\.offset) { index, answer in
                    GeometryReader { geometry in
                        let frame = geometry.frame(in: .global)
                        let midY = frame.midY
                        let screenHeight = UIScreen.main.bounds.height
                        let scale = min(1.0, 1 - abs(midY - screenHeight / 2) / (screenHeight / 2))
                        SingleAnswerView(answer: answer)
                            .scaleEffect(scale) // 중앙에 위치할수록 더 크게 표시
                            .frame(height: self.cardHeight)
                            .padding()
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(currentIndex: index)
                            }
                    }
                }.frame(height: self.cardHeight) // GeometryReader에도 높이 설정
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

struct TodayAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        TodayAnswerView()
    }
}

