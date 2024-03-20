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
                        HStack(spacing: 20) {
                            Button {
                                // TODO: - 답변하기 리프레시
                            } label: {
                                Text("답변하기")
                                    .font(.pretendard(.semiBold, size: 14))
                                    .foregroundStyle(TextLabel.main)
                            }
                            Button {
                                tab = .collecting
                            } label: {
                                Text("모아보기")
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
                                .frame(width: 24 , height: 24)
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
        .onAppear {
            viewModel.startTimer()
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
            
            Text(viewModel.timerSeconds)
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
                if viewModel.state == .ready {
                    pathModel.paths.append(.answer)
                } else {
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
                    
                    Text("아직 답변이 없어요.\n첫번째 답변을 작성해주세요!")
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
                        
                        Text(viewModel.listTitleText)
                            .font(.pretendard(.bold, size: 20))
                            .foregroundStyle(TextLabel.main)
                        
                        Spacer()
                            .frame(height: 32)
                        
                        HStack {
                            Text(viewModel.listSubText)
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(TextLabel.sub3)
                            
                            Spacer()
                            
                            if viewModel.state != .ready {
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
                    
                 //   Spacer()
                    
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
                       // .padding(.bottom, 16)
                    }
                    
                //    Spacer()
                     //   .frame(height: 32)
                }
            }
        }
    }
}

#Preview {
    TodayQuestionView(viewModel: TodayQuestionViewModel(), tab: .constant(.answering))
}
