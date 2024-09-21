//
//  AnswerCell.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

// MARK: - TodayQuestionCell

struct AnswerCell: View {
    
    let answer: Answer
    let isWrittenAnswerCell: Bool
    let seeMoreAction: () -> Void
    
    init(
        answer: Answer,
        isWrittenAnswerCell: Bool = false,
        seeMoreAction: @escaping () -> Void
    ) {
        self.answer = answer
        self.isWrittenAnswerCell = isWrittenAnswerCell
        self.seeMoreAction = seeMoreAction
    }
    
    var body: some View {
        if answer.isMine {
            NormalAnswerCell(
                answer: answer,
                isWrittenAnswerCell: isWrittenAnswerCell,
                seeMoreAction: seeMoreAction
            )
        } else {
            if answer.isReported {
                ReportAnswerCell(
                    answer: answer,
                    seeMoreAction: seeMoreAction
                )
            } else {
                NormalAnswerCell(
                    answer: answer,
                    isWrittenAnswerCell: isWrittenAnswerCell,
                    seeMoreAction: seeMoreAction
                )
            }
        }
    }
}

// MARK: - NormalAnswerCell

private struct NormalAnswerCell: View {
    
    let answer: Answer
    let isWrittenAnswerCell: Bool
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(
                answer: answer,
                isWrittenAnswerCell: isWrittenAnswerCell,
                seeMoreAction: seeMoreAction
            )
            .padding(.horizontal, 16)
            
            ContentView(answer: answer)
                .padding(.horizontal, 16)
            
            Divider()
                .padding(.top, 16)
        }
        .padding(.top, 8)
        .background(Background.first)
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let answer: Answer
    let isWrittenAnswerCell: Bool
    let seeMoreAction: () -> Void
    
    private var learnerName: String {
        if isWrittenAnswerCell {
            return answer.nickname
        } else if answer.nickname == "알 수 없음" {
            return "(알 수 없음)"
        } else {
            return "러너 \(answer.learnerIndex + 1)"
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
             Text(learnerName)
                .pretendard(.semiBold, 14)
                .foregroundStyle(GrayScale.icon)
                .padding(.leading, 8)
            
            Text("\(answer.writingDate.timeAgo)")
                .pretendard(.regular, 14)
                .foregroundStyle(TextLabel.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(GrayScale.icon)
            }
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let answer: Answer
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(answer.content)
                    .pretendard(.medium, 16)
                    .foregroundStyle(TextLabel.main)
                    .padding(.top, 2)
            }
        }
    }
}

// MARK: - ReportAnswerCell

private struct ReportAnswerCell: View {
    
    @State private var isReportContentShow = false
    
    let answer: Answer
    let seeMoreAction: () -> Void
    
    private var learnerName: String {
        if answer.nickname == "알 수 없음" {
            return answer.nickname
        } else {
            return "러너 \(answer.learnerIndex + 1)"
        }
    }
    
    var body: some View {
        if !isReportContentShow {
            VStack(alignment: .leading, spacing: 16) {
                Text("신고 되어 내용을 검토 중인 답변이에요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.sub3)
                    .padding(.horizontal, 16)
                
                HStack {
                    Button {
                        isReportContentShow.toggle()
                    } label: {
                        Text("답변 보기")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(BrandPink.text)
                    }
                    
                    Text("주의) 부적절한 콘텐츠가 포함될 수 있어요")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub4)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                Divider()
                    .padding(.top, 16)
            }
            .padding(.top, 16)
            .background(Background.first)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Image(.profileDummy)
                        .resizable()
                        .frame(width: 28, height: 28)
                    
                    Text(learnerName)
                        .pretendard(.semiBold, 14)
                        .foregroundStyle(GrayScale.icon)
                        .padding(.leading, 8)
                    
                    Text("\(answer.writingDate.timeAgo)")
                        .pretendard(.regular, 14)
                        .foregroundStyle(TextLabel.sub4)
                        .padding(.leading, 6)
                    
                    Spacer()
                    
                    Button {
                        isReportContentShow.toggle()
                    } label: {
                        Text("답변 숨기기")
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(BrandPink.text)
                    }
                }
                .padding(.horizontal, 16)
                
                ContentView(answer: answer)
                    .padding(.horizontal, 16)
                
                Divider()
                    .padding(.top, 16)
            }
            .padding(.top, 8)
            .background(Background.first)
        }
    }
}

// MARK: - Preview

#Preview {
    AnswerCell(
        answer: Answer(
            id: 0,
            writerId: 0,
            learnerIndex: 0,
            nickname: "한톨",
            content: "아! 이게 질문이 아니고 답변이구나!",
            writingDate: .now,
            isMine: true,
            isReported: true
        )
    ) {}
}
