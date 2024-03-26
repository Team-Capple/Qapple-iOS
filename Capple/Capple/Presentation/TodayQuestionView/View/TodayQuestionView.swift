//
//  TodayQuestionView.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct TodayQuestionView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject var viewModel: TodayQuestionViewModel = .init()
    
    @Binding var tab: Tab
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomNavigationBar(
                    leadingView: {},
                    principalView: {
                        HStack(spacing: 28) {
                            Button {
                                viewModel.updateTodayQuestionView()
                            } label: {
                                Text("오늘의 질문")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.main)
                            }
                            Button {
                                tab = .collecting
                            } label: {
                                Text("질문 리스트")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.sub4)
                            }
                        }
                        .font(Font.pretendard(.semiBold, size: 14))
                        .foregroundStyle(TextLabel.sub4)
                    },
                    trailingView: {
                        Button {
                            pathModel.paths.append(.myPage)
                        } label: {
                            Image(.capple)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32 , height: 32)
                        }
                    },
                    backgroundColor: Background.second)
                ScrollView {
                    VStack(spacing: 0) {
                        
                        HeaderView(viewModel: viewModel)
                        
                        HeaderButtonView(viewModel: viewModel, tab: $tab)
                        
                        AnswerPreview(viewModel: viewModel, isBottomSheetPresented: $isBottomSheetPresented)
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    viewModel.updateTodayQuestionView()
                }
            }
            .background(Background.second)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
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
            
            Text("\(viewModel.timeString())")
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
    
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject private var viewModel: TodayQuestionViewModel
    @Binding var tab: Tab
    
    fileprivate init(viewModel: TodayQuestionViewModel, tab: Binding<Tab>) {
        self.viewModel = viewModel
        self._tab = tab
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
                    pathModel.paths.append(
                        .answer(
                            questionId: viewModel.mainQuestion.questionId,
                            questionContent: viewModel.mainQuestion.content
                        )
                    )
                } else {
                    
                    // 답변 했으면 답변 보기 뷰로 이동
                    pathModel.paths.append(
                        .todayAnswer(
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
    
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject private var viewModel: TodayQuestionViewModel
    @Binding private var isBottomSheetPresented: Bool
    
    fileprivate init(
        viewModel: TodayQuestionViewModel,
        isBottomSheetPresented: Binding<Bool>
    ) {
        self.viewModel = viewModel
        self._isBottomSheetPresented = isBottomSheetPresented
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
                            Text("Q.")
                                .foregroundStyle(BrandPink.text)
                            
                            Text(viewModel.mainQuestion.content)
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
                                    pathModel.paths.append(
                                        .todayAnswer(
                                            questionId: viewModel.mainQuestion.questionId,
                                            questionContent: viewModel.mainQuestion.content
                                        )
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Separator()
                        .padding(.leading, 24)
                    
                    // 답변 있는 케이스
                    ForEach(viewModel.answerList, id: \.self) { answer in
                        VStack {
                            AnswerCell(
                                profileName: answer.nickname,
                                answer: answer.content,
                                keywords: answer.tags.splitTag
                            ) {
                                isBottomSheetPresented.toggle()
                            }
                            .sheet(isPresented: $isBottomSheetPresented) {
                                SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                    .presentationDetents([.height(84)])
                            }
                            
                            Separator()
                                .padding(.leading, 24)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TodayQuestionView(viewModel: TodayQuestionViewModel(), tab: .constant(.answering))
}
