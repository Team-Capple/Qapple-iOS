//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI
struct TodayAnswerView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: TodayAnswersViewModel = .init()
    
    @State private var isBottomSheetPresented = false
    
    var questionContent: String = "완전기본값제공" // 여기에 기본값을 제공합니다.
    var questionId: Int =  1// 여기에 기본값을 제공합니다.
    
    init(questionId: Int, questionContent: String) {
        self.questionContent = questionContent
        self.questionId = questionId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationView()
            Spacer()
                .frame(height: 16)
            
            FloatingQuestionCard(
                questionContent: questionContent,
                viewModel: viewModel,
                questionId: questionId
            )
            
            Spacer()
                .frame(height: 24)
            
            AnswerScrollView(
                viewModel: viewModel,
                isBottomSheetPresented: $isBottomSheetPresented,
                questionId: questionId
            )
            .refreshable {
                Task {
                    viewModel.loadAnswersForQuestion(questionId: questionId)
                    HapticManager.shared.impact(style: .light)
                }
            }
            
        }
        .navigationBarBackButtonHidden()
        .background(Color.Background.first)
        .onAppear {
            Task {
                viewModel.loadAnswersForQuestion(questionId: questionId)
            }
        }
    }
}

// MARK: - 커스텀 네비게이션
private struct CustomNavigationView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        CustomNavigationBar(
            leadingView:{
                CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.paths.removeLast()
                }
            },
            principalView: {
                Text("답변 리스트")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
                
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
            HStack {
                ForEach(viewModel.keywords, id: \.self) { keyword in
                    KeywordSelector(
                        keywordText: keyword,
                        keywordCount: 13) {
                            // TODO: 키워드 선택
                        }
                }
            }
        }
    }
}

// MARK: - 플로팅 질문 카드
private struct FloatingQuestionCard: View {
    
    var questionContent: String // 질문 내용을 저장할 프로퍼티
    @ObservedObject var viewModel: TodayAnswersViewModel // 뷰 모델
    @State private var isCardExpanded = true // 카드 확장 상태
    @State private var isArrowActive = true
    var questionId: Int?  // 추가됨
    
    var questionMark: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        return questionMark
    }
    
    var creatingText: AttributedString {
        let creatingText = AttributedString("\(questionContent)")
        return creatingText
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .top){
                Text(questionMark)
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
                Text(creatingText)
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .lineLimit(isCardExpanded ? 3 : 0)
            }
            
            Spacer()
            
            Image(isArrowActive ? .arrowUp : .arrowDown)
                .resizable()
                .scaledToFill()
                .frame(width: 28, height: 28)
                .foregroundColor(.white)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(GrayScale.secondaryButton)
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .onTapGesture {
            isArrowActive.toggle()
            withAnimation {
                isCardExpanded.toggle() // 확장/축소 상태 토글
            }
        }
    }
}

// MARK: - 답변 스크롤 뷰
private struct AnswerScrollView: View {
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: TodayAnswersViewModel
    @Binding private var isBottomSheetPresented: Bool
    @State private var isMyAnswer: IsMyAnswer?
    
    let questionId: Int
    
    fileprivate init(viewModel: TodayAnswersViewModel, isBottomSheetPresented: Binding<Bool>, questionId: Int) {
        self.viewModel = viewModel
        self._isBottomSheetPresented = isBottomSheetPresented
        self.questionId = questionId
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(Array(viewModel.answers.enumerated()), id: \.offset) {
                index,
                answer in
                VStack{
                    SingleAnswerView(answer: answer, isReported: answer.isReported) {
                        isMyAnswer = .init(
                            answerId: answer.answerId,
                            isMine: answer.isMyAnswer
                        )
                    }
                    
                    Separator()
                        .padding(.leading, 24)
                }
            }
            .sheet(item: $isMyAnswer) {
                SeeMoreView(
                    answerType: $0.isMine ? .mine : .others,
                    answerId: $0.answerId
                ) {
                    Task {
                        viewModel.loadAnswersForQuestion(questionId: questionId)
                    }
                }
                .presentationDetents([.height(84)])
            }
        }
    }
}

#Preview {
    TodayAnswerView(
        questionId: 1,
        questionContent: "디폴트"
    )
    .environmentObject(PathModel())
}
