//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI
struct TodayAnswerView: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    init(questionId: Int?) {
        self.viewModel = TodayAnswersViewModel(questionId: questionId ?? 1)
    }

     
    var body: some View {
        @ObservedObject var sharedData = SharedData()

        VStack(alignment: .leading) {
            CustomNavigationView()
           // KeywordScrollView(viewModel: viewModel)
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
            trailingView: {},
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
    @ObservedObject var sharedData = SharedData()
     
    let seeMoreAction: () -> Void
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isBottomSheetPresented = false
   
    init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
        sharedData = SharedData()
        self.seeMoreAction = {}
        self.isBottomSheetPresented = false
    }
  
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                ForEach(Array(viewModel.answers.enumerated()), id: \.offset) { index, answer in
                        SingleAnswerView(answer: answer, seeMoreAction: {
                            print(index)
                            isBottomSheetPresented.toggle()
                        }, seeMoreReport: {
                            return CGPoint(x: 10.0, y: 10.0)
                            // print(CGFloat(geometry.size.height))
                         //   sharedData.offset = CGFloat(index+1)
                          //  return CGPoint(x: geometry.frame(in: .global).minX, y: geometry.frame(in: .global).minY)
                            
                        })
                        .onTapGesture {self.sharedData.reportButtonPosition = CGPoint(x: 270, y: -index * 100)            }
                        
                        .sheet(isPresented: $isBottomSheetPresented) {
                            SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                .presentationDetents([.height(84)])
                        }
                    }
                    
                
        }
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 20)
                }
            }
        .padding(.horizontal,24)
        

            
        
    }
}

#Preview {
    TodayAnswerView(questionId: 1)
}

