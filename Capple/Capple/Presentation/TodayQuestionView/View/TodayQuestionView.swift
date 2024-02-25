//
//  TodayQuestionView.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct TodayQuestionView: View {
    
    @StateObject var viewModel: TodayQuestionViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: { },
                principalView: {
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Text("답변하기")
                        }
                        Button {
                            
                        } label: {
                            Text("모아보기")
                        }
                    }
                    .font(Font.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.main)
                },
                trailingView: {
                    HStack(spacing: 8) {
                        Button {
                            
                        } label: {
                            Image("NoticeIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24 , height: 24)
                        }
                        
                        NavigationLink(destination: MyPageView()) {
                            Image("Capple")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24 , height: 24)
                        }
                    }
                },
                backgroundColor: Background.second)
            ScrollView {
                VStack(spacing: 0) {
                    
                    HeaderView(viewModel: viewModel)
                    
                    HeaderButtonView(viewModel: viewModel)
                    
                    AnswerPreview(viewModel: viewModel)
                }
            }
        }
        //        .ignoresSafeArea()
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
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
                
                HeaderContentView(viewModel: viewModel)
                
                Spacer()
                    .frame(height: 20)
            }
            .frame(height: 260)
        }
//        .ignoresSafeArea()
        .onAppear {
            viewModel.startTimer()
        }
    }
}

// MARK: - HeaderTextView
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
            
            Image(.timer)
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
            
            Image(.ready)
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
            
            Image(.complete)
                .resizable()
                .scaledToFit()
                .frame(width: 120 , height: 120)
        }
    }
}

// MARK: - HeaderButtonView
private struct HeaderButtonView: View {
    
    @ObservedObject private var viewModel: TodayQuestionViewModel
    
    fileprivate init(viewModel: TodayQuestionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
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
                // TODO: - 이전 답변, 답변하기, 다른 답변 Navigation 연결
                print("timeZone: \(viewModel.timeZone)")
                print("state: \(viewModel.state)")
            }
        }
    }
}

// MARK: - AnswerPreview
private struct AnswerPreview: View {
    
    @ObservedObject private var viewModel: TodayQuestionViewModel
    
    fileprivate init(viewModel: TodayQuestionViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .leading) {
            Color(Background.first)
                .ignoresSafeArea()
            
            // 상단 타이틀
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
                            .frame(height: 10)
                        
                        Spacer()
                        
                        SeeAllButton()
                    }
                }
                .padding(.horizontal, 24)
                
                Separator()
                    .padding(.leading, 24)
                
                Spacer()
                
                ForEach(viewModel.answerList, id: \.self) { _ in
                    VStack(spacing: 24) {
                        AnswerCell()
                            .padding(.horizontal, 24)
                        
                        Separator()
                            .padding(.leading, 24)
                    }
                    .padding(.bottom, 16)
                }
                
                Spacer()
                    .frame(height: 32)
            }
        }
    }
}

#Preview {
    TodayQuestionView(viewModel: TodayQuestionViewModel())
}
