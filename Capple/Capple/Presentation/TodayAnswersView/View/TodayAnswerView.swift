//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI

struct TodayAnswerView: View {
    
    @StateObject var viewModel = TodayAnswersViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationView()
            KeywordScrollView(viewModel: viewModel)
            FloatingQuestionCard(viewModel: viewModel)
            AnswerScrollView(viewModel: viewModel)
        }
        .background(Color.Background.first)
        .navigationBarBackButtonHidden()
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

// MARK: - 플로팅 질문 카드
private struct FloatingQuestionCard: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isCardExpanded: Bool = true
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if isCardExpanded { // 카드가 확장되어 있는 경우에만 내용을 보여줍니다.
            HStack {
                Image(systemName: "q.circle.fill") // Q 아이콘 추가
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                
                Text(viewModel.todayQuestion)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                
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
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                /*
                 ForEach(viewModel.filteredAnswer) { answer in
                 SingleAnswerView(answer: answer) // 각 질문에 대한 뷰를 생성합니다.
                 .onAppear {
                 viewModel.loadMoreContentIfNeeded(currentItem: answer) // 필요한 경우 더 많은 내용을 로드합니다.
                 }
                 .padding(.vertical, 8) // 질문 사이의 수직 패딩을 추가합니다.
                 .background(Color.black) // 각 질문의 배경색을 검정색으로 설정합니다.
                 }
                 if viewModel.isLoading { // 로딩 중인 경우 로딩 인디케이터를 표시합니다.
                 ProgressView()
                 .scaleEffect(1.5)
                 .progressViewStyle(CircularProgressViewStyle(tint: .white))
                 }
                 */
                
                ForEach(viewModel.answers.indices, id: \.self) {
                    index in
                    GeometryReader { geometry in
                        
                        let frame = geometry.frame(in: .global)
                        let midY = frame.midY
                        let midX = frame.midX
                        let screenHeight = UIScreen.main.bounds.height
                        let scale = min(1.0, 1 - abs(midY - screenHeight / 2) / midX)
                        
                        SingleAnswerView(answer: viewModel.filteredAnswer[index])
                            .frame(width: geometry.size.width)
                            .frame(height: self.cardHeight)
                            .padding()
                            .background(Color.Background.second)
                            .opacity(1)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 2)
                            .scaleEffect(scale) // 현재 보이는 카드를 기준으로 크기 조정
                            .opacity(scale) // 중앙에 위치할수록 더 뚜렷하게 보이도록 설정
                            .onAppear {
                                if index == viewModel.answers.count - 1 { // 마지막 항목에 도달하면 더 많은 데이터 로드
                                    viewModel.loadMoreAnswers()
                                }
                            }
                    }
                    .frame(height: self.cardHeight) // GeometryReader에도 높이 설정
                }
                
            }
        }
    }
}

#Preview {
    TodayAnswerView()
}
