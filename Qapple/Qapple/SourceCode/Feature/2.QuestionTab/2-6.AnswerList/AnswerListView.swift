//
//  AnswerListView.swift
//  Qapple
//
//  Created by 김민준 on 1/24/25.
//

import ComposableArchitecture
import SwiftUI

struct AnswerListView: View {
    
    @Bindable var store: StoreOf<AnswerListFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            AnswerListNavigationBar(store: store)
            
            FloatingQuestionCard(question: store.question)
                .padding(.top, 16)
                .padding(.horizontal, 16)
            
            AnswerCountLabel(count: store.totalCount)
                .padding(.top, 16)
                .padding(.horizontal, 20)
            
            AnswerList(store: store)
                .padding(.top, 8)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureEnabled(true)
        .onAppear {
            store.send(.onAppear)
        }
        .refreshable {
            store.send(.refresh)
        }
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(
            state: \.sheet,
            action: \.sheet)
        ) { store in
            switch store.case {
            case let .seeMore(store): SeeMoreSheet(store: store)
            }
        }
    }
}

// MARK: - AnswerListNavigationBar

private struct AnswerListNavigationBar: View {
    
    let store: StoreOf<AnswerListFeature>
    
    var body: some View {
        QPNavigationBar(
            title: "답변 리스트",
            leadingView: {
                QPNavigationButton(buttonType: .back) {
                    store.send(.backButtonTapped)
                }
            }
        )
    }
}

// MARK: - FloatingQuestionCard

private struct FloatingQuestionCard: View {
    
    let question: Question
    
    var questionMark: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = .text
        return questionMark
    }
    
    var creatingText: AttributedString {
        let creatingText = AttributedString(question.content)
        return creatingText
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(questionMark)
                .font(.pretendard(.semiBold, size: 15))
                .foregroundStyle(TextLabel.main)
            
            Text(creatingText)
                .font(.pretendard(.semiBold, size: 15))
                .foregroundStyle(TextLabel.main)
                .lineSpacing(6)
                .lineLimit(3)
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(.secondaryButton)
        .cornerRadius(15)
    }
}

// MARK: - AnswerCountLabel

private struct AnswerCountLabel: View {
    
    let count: Int
    
    var body: some View {
        HStack {
            Text("\(count)개의 답변")
                .font(.pretendard(.semiBold, size: 15))
                .foregroundStyle(.sub3)
            
            Spacer()
        }
    }
}

// MARK: - AnswerList

private struct AnswerList: View {
    
    let store: StoreOf<AnswerListFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if case let .popularAnswer(answer, question) = store.state.popularAnswerStatus {
                    QPPopularAnswerCell(status: .popularAnswer(answer, question))
                        .padding(.horizontal, 16)
                }
                
                ForEach(enumerated(store.answerList), id: \.element.id) {
                    index, answer in
                    Button {
                        store.send(.answerCommentButtonTapped(answer))
                    } label: {
                        QPAnswerCell(
                            answer: answer,
                            index: index,
                            state: .normal,
                            seeMoreAction: {
                                store.send(.seeMoreAction(answer))
                            },
                            likeAction: {
                                store.send(.likeAnswerButtonTapped(answer))
                            },
                            commentAction: {
                                store.send(.answerCommentButtonTapped(answer))
                            }
                        )
                    }
                    .configurePagination(
                        store.answerList,
                        currentIndex: index,
                        hasNext: store.paginationInfo.hasNext,
                        pagination: {
                            
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let question = Question(id: 0, content: "테스트 질문", publishedDate: .now, isAnswered: true, isLived: false)
    AnswerListView(store: Store(initialState: AnswerListFeature.State(question: question)) {
        AnswerListFeature()
    })
}
