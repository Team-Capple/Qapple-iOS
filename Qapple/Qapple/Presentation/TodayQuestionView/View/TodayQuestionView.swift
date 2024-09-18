//
//  TodayQuestionView.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct TodayQuestionView: View {
    
    @EnvironmentObject private var homePathModel: Router
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject var viewModel: TodayQuestionViewModel = .init()
    
    @State private var isBottomSheetPresented = false
    
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(viewModel: viewModel)
                    HeaderButtonView(viewModel: viewModel)
                    AnswerPreview(viewModel: viewModel, isBottomSheetPresented: $isBottomSheetPresented)
                }
            }
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.updateTodayQuestionView()
                HapticManager.shared.impact(style: .light)
            }
            .background(Background.second)
            .onAppear {
                viewModel.updateTodayQuestionView()
            }
            .onReceive(NotificationCenter.default.publisher(for: .updateViewNotification)) { _ in
                print("뷰 업데이트")
                viewModel.updateTodayQuestionView()
            }
        }
    }
}

// MARK: - HeaderView
private struct HeaderView: View {
    
    @ObservedObject private var viewModel: TodayQuestionViewModel
    
    fileprivate init(viewModel: TodayQuestionViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ZStack {
            Color(Background.second)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 12)
                
                HeaderContentView(viewModel: viewModel)
                
                Spacer()
                    .frame(height: 20)
            }
            .frame(height: 260)
        }
    }
}

// MARK: - HeaderContentView
private struct HeaderContentView: View {
    
    @ObservedObject private var viewModel: TodayQuestionViewModel
    
    fileprivate init(viewModel: TodayQuestionViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        
        // 1. 질문 생성 중
        if viewModel.state == .creating {
            Text(viewModel.titleText)
                .font(.pretendard(.bold, size: 16))
                .foregroundStyle(.wh)
                .frame(height: 11)
            
            Spacer()
                .frame(height: 16)
            
            Text(viewModel.timeString())
                .font(.pretendard(.bold, size: 38))
                .foregroundColor(Color(red: 0.83, green: 0.41, blue: 0.98))
                .frame(height: 27)
                .monospacedDigit()
                .kerning(-2)
            
            Spacer()
                .frame(height: 10)
            
            Image(.questionCreate)
                .resizable()
                .scaledToFit()
                .frame(width: 120 , height: 120)
        }
        
        // 2. 질문 준비 완료
        else if viewModel.state == .ready {
            Text(viewModel.titleText)
                .font(.pretendard(.bold, size: 23))
                .foregroundStyle(.wh)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 10)
            
            Image(.questionReady)
                .resizable()
                .scaledToFit()
                .frame(width: 120 , height: 120)
        }
        
        // 3. 답변 완료
        else if viewModel.state == .complete {
            Text(viewModel.titleText)
                .font(.pretendard(.bold, size: 23))
                .foregroundStyle(.wh)
                .lineSpacing(6)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 10)
            
            Image(.questionComplete)
                .resizable()
                .scaledToFit()
                .frame(width: 120 , height: 120)
        }
    }
}

// MARK: - HeaderButtonView
private struct HeaderButtonView: View {
    
    @EnvironmentObject private var pathModel: Router
    @ObservedObject private var viewModel: TodayQuestionViewModel
    
    fileprivate init(viewModel: TodayQuestionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color(Background.first)
            
            Rectangle()
                .frame(height: 28)
                .foregroundStyle(Background.second)
                .cornerRadius(32, corners: .bottomLeft)
                .cornerRadius(32, corners: .bottomRight)
            
            TodayQuestionActionButton(
                viewModel.buttonText,
                priority: viewModel.state == .ready
                ? .primary : .secondary
            ) {
                if !viewModel.mainQuestion.isAnswered {
                    
                    // 답변 안했으면 답변하기 뷰로 이동
                    pathModel.pushView(
                        screen: QuestionListPathType.answer(
                            questionId: viewModel.mainQuestion.questionId,
                            questionContent: viewModel.mainQuestion.content
                        )
                    )
                } else {
                    
                    // 답변 했으면 답변 보기 뷰로 이동
                    pathModel.pushView(
                        screen: QuestionListPathType.todayAnswer(
                            questionId: viewModel.mainQuestion.questionId,
                            questionContent: viewModel.mainQuestion.content
                        )
                    )
                }
            }
        }
    }
}

// MARK: - AnswerPreview
private struct AnswerPreview: View {
    
    @EnvironmentObject private var pathModel: Router
    @ObservedObject private var viewModel: TodayQuestionViewModel
    @State private var isMine: IsMyAnswer?
    
    fileprivate init(
        viewModel: TodayQuestionViewModel,
        isBottomSheetPresented: Binding<Bool>
    ) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .leading) {
            Color(Background.first)
                .padding(.bottom, -720)
            
            // 답변 리스트 유무에 따른 화면 분기
            if viewModel.answerList.isEmpty {
                HStack {
                    Spacer()
                    
                    Text("오늘 질문에 대한 답변이 아직 없어요\n답변하러 가볼까요?")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(TextLabel.sub3)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.top, 140)
                    
                    Spacer()
                }
            } else {
                VStack(spacing: 14) {
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: 44)
                        
                        HStack(alignment: .top, spacing: 2) {
                            
                            if viewModel.mainQuestion.isAnswered {
                                Text("Q.")
                                    .foregroundStyle(BrandPink.text)
                            }
                            
                            Text(viewModel.listTitleText)
                                .foregroundStyle(TextLabel.main)
                        }
                        .font(.pretendard(.bold, size: 20))
                        .lineSpacing(4)
                        
                        Spacer()
                            .frame(height: 24)
                        
                        HStack {
                            Text(viewModel.listSubText)
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(TextLabel.sub3)
                            
                            Spacer()
                            
                            if viewModel.mainQuestion.isAnswered {
                                SeeAllButton {
                                    pathModel.pushView(
                                        screen: QuestionListPathType.todayAnswer(
                                            questionId: viewModel.mainQuestion.questionId,
                                            questionContent: viewModel.mainQuestion.content
                                        )
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // 답변 있는 케이스
                    ForEach(viewModel.answerList, id: \.self) { answer in
                        VStack {
                            AnswerCell(
                                answer: Answer(
                                    id: answer.answerId,
                                    writerId: answer.writerId,
                                    content: answer.content,
                                    writingDate: answer.writeAt.ISO8601ToDate,
                                    isMine: answer.isMine,
                                    isReported: answer.isReported
                                ),
                                seeMoreAction: {
                                    isMine = .init(
                                        answerId: answer.answerId,
                                        isMine: answer.isMine
                                    )
                                }
                            )
                        }
                    }
                    .sheet(item: $isMine) {
                        SeeMoreView(
                            answerType: $0.isMine ? .mine : .others,
                            answerId: $0.answerId
                        ) {
                            viewModel.updateTodayQuestionView()
                        }
                        .presentationDetents([.height(84)])
                    }
                }
            }
        }
    }
}

#Preview {
    TodayQuestionView(viewModel: TodayQuestionViewModel())
}
