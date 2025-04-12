//
//  TodayQuestionView.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import ComposableArchitecture
import SwiftUI

struct TodayQuestionView: View {
    
    @Bindable var store: StoreOf<TodayQuestionFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(store: store)
            
            ScrollView {
                AnswerPreviewList(store: store)
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            store.send(.onAppear)
        }
        .refreshable {
            store.send(.refresh)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(state: \.sheet, action: \.sheet)) { store in
            switch store.case {
            case let .seeMore(store): SeeMoreSheet(store: store)
            }
        }
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let store: StoreOf<TodayQuestionFeature>
    
    var body: some View {
        HStack(spacing: 8) {
            Image(store.questionState.graphicImage)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
            
            Text(store.questionState.mainTitle)
                .font(.pretendard(.semiBold, size: 18))
                .foregroundStyle(.wh)
                .tracking(-1)
            
            Spacer()
            
            if store.questionState == .creating {
                QuestionTimer()
            } else {
                AnsweringButton()
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .background(.second)
        .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
    }
    
    /// 질문 타이머
    private func QuestionTimer() -> some View {
        Text(store.timeRemainingForQuestion.timerFormat)
            .font(.pretendard(.bold, size: 22))
            .foregroundStyle(LinearGradient.timer)
            .monospacedDigit()
            .kerning(-2)
    }
    
    /// 답변하기 버튼
    private func AnsweringButton() -> some View {
        Button {
            store.send(.questionButtonTapped(store.todayQuestion))
        } label: {
            Text(title)
                .font(.pretendard(.semiBold, size: 15))
                .frame(width: 84)
                .padding(.vertical, 10)
                .foregroundStyle(.main)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .opacity(store.isLoading ? 0 : 1)
        .buttonStyle(ScalableButtonStyle())
    }
    
    /// 버튼 제목
    private var title: String {
        store.questionState.buttonTitle(
            isAnswerd: store.todayQuestion.isAnswered
        )
    }
    
    /// 버튼 배경 색상
    private var backgroundColor: Color {
        switch store.questionState {
        case .creating:
            store.todayQuestion.isAnswered ? .secondaryButton : .button
        case .ready: .button
        case .complete: .secondaryButton
        }
    }
}

private struct LegacyHeaderView: View {
    
    @State private var offsetY: CGFloat = 0
    
    let store: StoreOf<TodayQuestionFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                Image(store.questionState.graphicImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .offset(y: offsetY)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                            offsetY = -20
                        }
                    }
                
                Text(store.questionState.mainTitle)
                    .font(.pretendard(.bold, size: 23))
                    .foregroundStyle(.wh)
                    .tracking(-1)
                    .padding(.top, 20)
                
                if store.questionState == .creating {
                    Text(store.timeRemainingForQuestion.timerFormat)
                        .font(.pretendard(.bold, size: 38))
                        .foregroundStyle(LinearGradient.timer)
                        .frame(height: 27)
                        .padding(.top, 12)
                        .monospacedDigit()
                        .kerning(-2)
                }
            }
            .opacity(store.isLoading ? 0 : 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: store.questionState == .creating ? 270 : 230)
        .background(.second)
    }
}

// MARK: - QuestionButton

private struct QuestionButton: View {
    
    let store: StoreOf<TodayQuestionFeature>
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(height: 28)
                .foregroundStyle(.second)
                .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
            
            Button {
                store.send(.questionButtonTapped(store.todayQuestion))
            } label: {
                Text(title)
                    .font(.pretendard(.semiBold, size: 17))
                    .frame(width: 168)
                    .padding(.vertical, 14)
                    .foregroundStyle(.main)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .opacity(store.isLoading ? 0 : 1)
            .buttonStyle(ScalableButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .background(.first)
    }
    
    /// 버튼 제목
    private var title: String {
        store.questionState.buttonTitle(
            isAnswerd: store.todayQuestion.isAnswered
        )
    }
    
    /// 버튼 배경 색상
    private var backgroundColor: Color {
        switch store.questionState {
        case .creating:
            store.todayQuestion.isAnswered ? .secondaryButton : .button
        case .ready: .button
        case .complete: .secondaryButton
        }
    }
}

// MARK: - AnswerPreviewList

private struct AnswerPreviewList: View {
    
    let store: StoreOf<TodayQuestionFeature>
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .padding(.bottom, -720)
            
            VStack(spacing: 0) {
                Title()
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                
                SubTitle()
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                if store.answerPreviewList.isEmpty {
                    Spacer()
                    
                    Text("첫 답변을 달아보세요!")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(.sub4)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.top, 120)
                } else {
                    PreviewList()
                        .padding(.top, 14)
                }
            }
            .frame(maxWidth: .infinity)
            .opacity(store.isLoading ? 0 : 1)
        }
    }
    
    private func Title() -> some View {
        HStack(alignment: .top, spacing: 2) {
            Text("Q.")
                .foregroundStyle(.text)
            
            Text(store.todayQuestion.content)
                .foregroundStyle(.main)
            
            Spacer()
        }
        .font(.pretendard(.bold, size: 20))
        .lineSpacing(4)
    }
    
    private func SubTitle() -> some View {
        HStack {
            Text("답변 미리보기")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.sub3)
            
            Spacer()
            
            if store.todayQuestion.isAnswered {
                SeeAllButton {
                    store.send(.seeAllAnswerButtonTapped(store.todayQuestion))
                }
            }
        }
    }
    
    private func PreviewList() -> some View {
        VStack(spacing: 0) {
            ForEach(enumerated(store.answerPreviewList), id: \.element.id) {
                index, answer in
                QPAnswerCell(
                    answer: answer,
                    index: index,
                    state: .normal,
                    seeMoreAction: {
                        store.send(.seeMoreAnswerButtonTapped(answer))
                    }
                )
            }
        }
    }
}

// MARK: - SeeAllButton

private struct SeeAllButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 1) {
                Text("전체보기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.main)
                    .frame(height: 10)
                
                Image(.arrowRight)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let question = Question(
        id: 0,
        content: "테스트 질문입니다.",
        publishedDate: .now,
        isAnswered: true,
        isLived: true
    )
    let store = Store(
        initialState: TodayQuestionFeature.State(
            questionState: .creating,
            todayQuestion: question,
            answerPreviewList: [
                Answer(
                    id: 0,
                    writerId: 0,
                    content: "테스트 답변 01",
                    authorNickname: "테스트 러너 1",
                    authorGeneration: "3기",
                    publishedDate: .now,
                    isReported: false,
                    isMine: false,
                    isResignMember: false
                ),
                Answer(
                    id: 1,
                    writerId: 1,
                    content: "테스트 답변 02",
                    authorNickname: "테스트 러너 2",
                    authorGeneration: "4기",
                    publishedDate: .now,
                    isReported: false,
                    isMine: false,
                    isResignMember: false
                ),
                Answer(
                    id: 2,
                    writerId: 2,
                    content: "테스트 답변 03",
                    authorNickname: "테스트 러너 3",
                    authorGeneration: "3기",
                    publishedDate: .now,
                    isReported: false,
                    isMine: false,
                    isResignMember: false
                )
            ]
        )
    ) {
        TodayQuestionFeature()
    }
    NavigationStack {
        VStack {
            TodayQuestionView(store: store)
        }
    }
}
