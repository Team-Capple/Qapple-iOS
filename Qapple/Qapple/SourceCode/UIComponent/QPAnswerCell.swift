//
//  QPAnswerCell.swift
//  Qapple
//
//  Created by 김민준 on 1/21/25.
//

import SwiftUI

struct QPAnswerCell: View {
    
    enum State {
        case normal
        case written
    }
    
    let answer: Answer
    let index: Int
    let state: State
    let seeMoreAction: () -> Void
    let likeAction: () -> Void
    let commentAction: () -> Void
    
    var body: some View {
        switch state {
        case .normal:
            if answer.isReported {
                ReportedCell(
                    answer: answer,
                    index: index,
                    author: author(index: index)
                )
            } else {
                NormalCell(
                    answer: answer,
                    index: index,
                    author: author(index: index),
                    seeMoreAction: seeMoreAction,
                    likeAction: likeAction,
                    commentAction: commentAction
                )
            }
            
        case .written:
            NormalCell(
                answer: answer,
                index: index,
                author: answer.authorNickname,
                seeMoreAction: seeMoreAction,
                likeAction: likeAction,
                commentAction: commentAction
            )
        }
    }
    
    /// 작성자 이름 문자열
    private func author(index: Int) -> String {
        if answer.isResignMember { return "(알 수 없음)" }
        else { return "러너 \(index + 1)" }
    }
}

// MARK: - NormalCell

private struct NormalCell: View {
    
    let answer: Answer
    let index: Int
    let author: String
    let seeMoreAction: () -> Void
    let likeAction: () -> Void
    let commentAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if index > 0 {
                Divider()
            }
            
            Header()
                .padding(.top, 20)
                .padding(.horizontal, 16)
            
            Content()
                .padding(.top, 8)
                .padding(.horizontal, 16)
            
//            Footer()
//                .padding(.top, 6)
//                .padding(.bottom, 20)
//                .padding(.horizontal, 16)
        }
        .background(.first)
    }
    
    private func Header() -> some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(author)
                .pretendard(.semiBold, 14)
                .foregroundStyle(.icon)
                .padding(.leading, 8)
            
            Text(answer.authorGeneration.isEmpty ? "3기" : answer.authorGeneration)
                .pretendard(.medium, 10)
                .foregroundStyle(.main)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(.secondaryButton)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.leading, 6)
            
            Text(answer.publishedDate.timeAgo)
                .pretendard(.regular, 14)
                .foregroundStyle(.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.icon)
            }
        }
    }
    
    private func Content() -> some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            Text(answer.content)
                .pretendard(.medium, 16)
                .foregroundStyle(.main)
                .padding(.top, 2)
        }
    }
    
    private func Footer() -> some View {
        HStack(spacing: 0) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            Button {
                likeAction()
            } label: {
                HStack(spacing: 4) {
                    Image(true ? .heartActive : .heart)
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                    Text("32")
                        .pretendard(.regular, 13)
                        .foregroundStyle(.sub3)
                }
            }
            .padding(.leading, 8)
            
            Button {
                commentAction()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .frame(width: 15, height: 14)
                    
                    Text("32")
                        .pretendard(.regular, 13)
                }
                .foregroundStyle(.sub3)
            }
            .padding(.leading, 12)
        }
    }
}

// MARK: - ReportedCell

private struct ReportedCell: View {
    
    @State private var isReportContentShow = false
    
    let answer: Answer
    let index: Int
    let author: String
    
    var body: some View {
        Group {
            if isReportContentShow {
                ReportShowView()
            } else {
                ReportHideView()
            }
        }
        .opacity(0.5)
    }
    
    private func ReportHideView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if index > 0 {
                Divider()
            }
            
            HStack(alignment: .top) {
                Text("신고 되어 내용을 검토 중인 답변이에요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.sub3)
                
                Spacer()
                
                Button {
                    isReportContentShow.toggle()
                } label: {
                    Text("답변 보기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.text)
                }
            }
            .frame(height: 28)
            .padding(.top, 18)
            .padding(.horizontal, 16)
            
            HStack {
                Text("주의) 부적절한 콘텐츠가 포함될 수 있어요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.sub4)
                
                Spacer()
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
        }
        .background(.first)
    }
    
    private func ReportShowView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            Header()
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Content()
                .padding(.bottom, 0)
                .padding(.horizontal, 16)
        }
        .background(.first)
        .padding(.bottom, 16)
    }
    
    private func Header() -> some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(author)
                .pretendard(.semiBold, 14)
                .foregroundStyle(.icon)
                .padding(.leading, 8)
            
            Text(answer.publishedDate.timeAgo)
                .pretendard(.regular, 14)
                .foregroundStyle(.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                isReportContentShow.toggle()
            } label: {
                Text("답변 숨기기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.text)
            }
        }
    }
    
    private func Content() -> some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            Text(answer.content)
                .pretendard(.medium, 16)
                .foregroundStyle(.main)
                .padding(.top, 2)
        }
    }
}

// MARK: - Preview

#Preview {
    let answers = [
        Answer(
            id: 0,
            writerId: 0,
            content: "일반 답변",
            authorNickname: "시몬스",
            authorGeneration: "3기",
            publishedDate: .now,
            isReported: false,
            isMine: false,
            isResignMember: false
        ),
        Answer(
            id: 1,
            writerId: 1,
            content: "내 답변",
            authorNickname: "한톨",
            authorGeneration: "4기",
            publishedDate: .now,
            isReported: false,
            isMine: true,
            isResignMember: false
        ),
        Answer(
            id: 2,
            writerId: 2,
            content: "탈퇴한 답변",
            authorNickname: "무니",
            authorGeneration: "3기",
            publishedDate: .now,
            isReported: false,
            isMine: false,
            isResignMember: true
        ),
        Answer(
            id: 3,
            writerId: 3,
            content: "신고된 답변",
            authorNickname: "리버",
            authorGeneration: "4기",
            publishedDate: .now,
            isReported: true,
            isMine: false,
            isResignMember: false
        )
    ]
    ZStack {
        Color.first.ignoresSafeArea()
        
        VStack(alignment: .leading, spacing: 0) {
            QPAnswerCell(
                answer: answers[0],
                index: 0,
                state: .normal,
                seeMoreAction: {},
                likeAction: {},
                commentAction: {}
            )
            QPAnswerCell(
                answer: answers[1],
                index: 1,
                state: .normal,
                seeMoreAction: {},
                likeAction: {},
                commentAction: {}
            )
            QPAnswerCell(
                answer: answers[2],
                index: 2,
                state: .normal,
                seeMoreAction: {},
                likeAction: {},
                commentAction: {}
            )
            QPAnswerCell(
                answer: answers[3],
                index: 3,
                state: .normal,
                seeMoreAction: {},
                likeAction: {},
                commentAction: {}
            )
            QPAnswerCell(
                answer: answers[1],
                index: 4,
                state: .written,
                seeMoreAction: {},
                likeAction: {},
                commentAction: {}
            )
        }
    }
}
