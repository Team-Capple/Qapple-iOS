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
        ScrollView {
            
            ZStack {
                Color(Background.first)
                
                VStack(spacing: 0) {
                    WaitingQuestionView(viewModel: viewModel)
                    
                    TodayQuestionActionButtonView()
                    
                    AnswerPreview()
                }
            }
        }
        .ignoresSafeArea()
        .background(Background.first)
    }
}

// MARK: - WaitingQuestionView
private struct WaitingQuestionView: View {
    
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
                    .scaledToFit()
                    .frame(width: 120 , height: 120)
                
                Spacer()
                    .frame(height: 20)
            }
        }
        .frame(height: 348)
        .ignoresSafeArea()
        .onAppear {
            viewModel.startTimer()
        }
    }
}

// MARK: - TodayQuestionActionButtonView
private struct TodayQuestionActionButtonView: View {
    
    var buttonText = "이전 질문 보러가기"
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(height: 28)
                .foregroundStyle(Background.second)
                .cornerRadius(32, corners: .bottomLeft)
                .cornerRadius(32, corners: .bottomRight)
            
            TodayQuestionActionButton(buttonText)
        }
    }
}

// MARK: - AnswerPreview
private struct AnswerPreview: View {
    
    var questionMark: AttributedString = {
        var text = AttributedString("Q. ")
        text.foregroundColor = BrandPink.text
        return text
    }()
    
    var questionText: AttributedString = "아카데미 러너 중\n가장 마음에 드는 유형이 있나요?"
    var previewTitle = "이전 답변 좋아요 TOP 3"
    
    var answers = [1, 2, 3]
    
    fileprivate var body: some View {
        ZStack(alignment: .leading) {
            Color(Background.first)
                .ignoresSafeArea()
            
            /// 상단 타이틀
            VStack(spacing: 14) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 44)
                    
                    Text(questionMark + questionText)
                        .font(.pretendard(.bold, size: 20))
                        .foregroundStyle(TextLabel.main)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    HStack {
                        Text(previewTitle)
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
                
                ForEach(answers, id: \.self) { _ in
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
