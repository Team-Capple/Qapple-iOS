//
//  AnswerListView.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import SwiftUI

struct AnswerListView: View {
    
    @EnvironmentObject var pathModel: Router
    @StateObject var viewModel: AnswerListViewModel = .init()
    
    @State private var isBottomSheetPresented = false
    
    var questionContent: String = "완전기본값제공"
    var questionId: Int =  1
    
    init(questionId: Int, questionContent: String) {
        self.questionContent = questionContent
        self.questionId = questionId
    }
    
    var body: some View {
        ZStack {
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
                    .frame(height: 16)
                
                HStack(alignment: .top) {
                    Text("\(viewModel.total)개의 답변")
                        .font(.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.sub3)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                
                AnswerScrollView(
                    viewModel: viewModel,
                    isBottomSheetPresented: $isBottomSheetPresented,
                    questionId: questionId
                )
                .padding(.top, 6)
                .refreshable {
                    Task {
                        viewModel.refreshAnswersForQuestion(questionId: questionId)
                        HapticManager.shared.impact(style: .light)
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color.Background.first)
        .onAppear {
            Task {
                viewModel.loadAnswersForQuestion(questionId: questionId)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .updateViewNotification)) { _ in
            print("뷰 업데이트")
            Task {
                viewModel.loadAnswersForQuestion(questionId: questionId)
            }
        }
    }
}

// MARK: - 커스텀 네비게이션
private struct CustomNavigationView: View {
    
    @EnvironmentObject var pathModel: Router
    
    var body: some View {
        CustomNavigationBar(
            leadingView:{
                CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.pop()
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
    
    @ObservedObject var viewModel: AnswerListViewModel
    
    fileprivate init(viewModel: AnswerListViewModel) {
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
    @ObservedObject var viewModel: AnswerListViewModel // 뷰 모델
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
        HStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Text(questionMark)
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
                
                Text(creatingText)
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(GrayScale.secondaryButton)
        .cornerRadius(15)
        .padding(.horizontal, 16)
        .onTapGesture {
            isArrowActive.toggle()
            withAnimation {
                isCardExpanded.toggle()
            }
        }
    }
}

// MARK: - 답변 스크롤 뷰
private struct AnswerScrollView: View {
    @EnvironmentObject var pathModel: Router
    @ObservedObject var viewModel: AnswerListViewModel
    @Binding private var isBottomSheetPresented: Bool
    @State private var isMyAnswer: IsMyAnswer?
    
    let questionId: Int
    
    fileprivate init(viewModel: AnswerListViewModel, isBottomSheetPresented: Binding<Bool>, questionId: Int) {
        self.viewModel = viewModel
        self._isBottomSheetPresented = isBottomSheetPresented
        self.questionId = questionId
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.answerList.enumerated()), id: \.offset) { index, answer in
                    AnswerCell(
                        answer: Answer(
                            id: answer.answerId,
                            writerId: answer.writerId,
                            learnerIndex: viewModel.learnerIndex(to: answer),
                            nickname: answer.nickname,
                            content: answer.content,
                            writingDate: answer.writeAt.ISO8601ToDate,
                            isMine: answer.isMine,
                            isReported: answer.isReported
                        ),
                        seeMoreAction: {
                            isMyAnswer = .init(
                                answerId: answer.answerId,
                                isMine: answer.isMine
                            )
                        }
                    )
                    .onAppear {
                        if index == viewModel.answerList.count - 1
                            && viewModel.hasNext {
                            print("답변 페이지네이션")
                            viewModel.loadAnswersForQuestion(questionId: questionId)
                        }
                    }
                    
                    if index != viewModel.answerList.endIndex - 1 {
                        Divider()
                    }
                }
            }
        }
        .sheet(item: $isMyAnswer) {
            SeeMoreView(
                answerType: $0.isMine ? .mine : .others,
                answerId: $0.answerId
            ) {
                pathModel.pop()
            }
            .presentationDetents([.height(84)])
        }
    }
}

#Preview {
    AnswerListView(
        questionId: 1,
        questionContent: "디폴트"
    )
    .environmentObject(Router(pathType: .questionList))
}
