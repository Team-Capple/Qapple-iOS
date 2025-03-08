//
//  QuestionListView.swift
//  Qapple
//
//  Created by 김민준 on 1/22/25.
//

import ComposableArchitecture
import SwiftUI

struct QuestionListView: View {
    
    @Bindable var store: StoreOf<QuestionListFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            QuestionCountLabel()
                .padding(.horizontal, 24)
            
            QuestionList(store: store)
                .padding(.top, 8)
        }
        .background(.first)
        .onAppear {
            store.send(.onAppear)
        }
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    private func QuestionCountLabel() -> some View {
        HStack(alignment: .top) {
            Text("\(store.totalCount)개의 질문")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.sub3)
            
            Spacer()
        }
    }
}

// MARK: - QuestionList

private struct QuestionList: View {
    
    let store: StoreOf<QuestionListFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(enumerated(store.questionList), id: \.element.id) {
                    index, question in
                    Button {
                        store.send(.questionCellTapped(question))
                    } label: {
                        QuestionCell(
                            question: question,
                            answerButtonTapped: {
                                store.send(.answerButtonTapped(question))
                            }
                        )
                    }
                    .buttonStyle(ScalableButtonStyle())
                    .padding(.horizontal, 12)
                    .configurePagination(
                        store.questionList,
                        currentIndex: index,
                        hasNext: store.paginationInfo.hasNext,
                        pagination: {
                            store.send(.pagination)
                        }
                    )
                }
            }
        }
        .refreshable {
            store.send(.refresh)
        }
    }
}

// MARK: - QuestionCell

private struct QuestionCell: View {
    
    let question: Question
    let answerButtonTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Header()
            
            Text(question.content)
                .foregroundStyle(.main)
                .font(.pretendard(.bold, size: 17))
                .multilineTextAlignment(.leading)
                .lineSpacing(4.0)
                .lineLimit(2)
                .padding(.top, 6)
            
            AnswerButton()
                .padding(.top, 8)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cellColor)
                .stroke(cellStrokeColor, lineWidth: 1)
        )
    }
    
    private var cellColor: Color {
        question.isAnswered
        ? TextLabel.sub4.opacity(0.05)
        : Color.white.opacity(0.04)
    }
    
    private var cellStrokeColor: Color {
        question.isLived
        ? BrandPink.button.opacity(0.4)
        : .clear
    }
    
    /// 질문 기수
    private var questionGeneration: Int {
        let thirdEndDate = AcademyEventFor4th.fourthStart.period.1
        return thirdEndDate > Date.now ? 3 : 4
    }
}

// MARK: - QuestionCell SubView

extension QuestionCell {
    
    private func Header() -> some View {
        HStack(spacing: 8) {
            Text("#\(questionGeneration)기-\(question.id)번")
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(.icon)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 2, height: 10)
                .foregroundStyle(.icon.opacity(0.5))
            
            Text(question.publishedDate.formatting(.md))
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.icon)
            
            if question.isLived {
                Text("ON AIR")
                    .font(.pretendard(.bold, size: 11))
                    .foregroundColor(.main)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.white.opacity(0.08))
                            .stroke(.onAir, lineWidth: 0.33)
                    )
            }
            
            Spacer()
        }
    }
    
    private func AnswerButton() -> some View {
        HStack {
            Spacer()
            
            Button {
                answerButtonTapped()
            } label: {
                Text(question.isAnswered ? "답변완료" : "답변하기")
                    .font(.pretendard(question.isAnswered ? .medium : .semiBold, size: 14))
                    .foregroundStyle(question.isAnswered ? .disable : .main)
                    .frame(width: 70, height: 36)
                    .background(question.isAnswered ? .secondaryButton : .button)
                    .cornerRadius(30, corners: .allCorners)
            }
            .disabled(question.isAnswered)
        }
    }
}

// MARK: - Preview

#Preview {
    QuestionListView(store: Store(initialState: QuestionListFeature.State()) {
        QuestionListFeature()
    })
}
