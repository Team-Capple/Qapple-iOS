//
//  WrittenAnswerView.swift
//  Qapple
//
//  Created by 김민준 on 4/2/24.
//

import SwiftUI

struct WrittenAnswerView: View {
    
    @EnvironmentObject var pathModel: Router
    @StateObject private var viewModel: WrittenAnswerViewModel = .init()
    @State private var isBottomSheetPresented = false
    @State private var isMyAnswer: IsMyAnswer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                leadingView:{
                    CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.pop()
                    }
                },
                principalView: {
                    Text("작성한 답변")
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {},
                backgroundColor: .clear
            )
            
            Spacer()
            
            if viewModel.myAnswers.isEmpty {
                HStack {
                    Spacer()
                    Text("작성한 답변이 없어요")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.sub3)
                    Spacer()
                }
                
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(Array(viewModel.myAnswers.enumerated()), id: \.offset) { index, answer in
                        VStack {
                            AnswerCell(
                                answer: Answer(
                                    id: answer.answerId,
                                    anonymityId: 0, // TODO: 더미데이터 바꾸기
                                    content: answer.content,
                                    writingDate: .now, // TODO: 더미데이터 바꾸기,
                                    isReported: false
                                ),
                                seeMoreAction: {
                                    isMyAnswer = .init(answerId: answer.answerId, isMine: true)
                                }
                            )
                            
                            Separator()
                                .padding(.leading, 24)
                        }
                    }
                }
                .sheet(item: $isMyAnswer) {
                    SeeMoreView(
                        answerType: .mine,
                        answerId: $0.answerId
                    ) {
                        Task {
                            await viewModel.requestAnswers()
                        }
                    }
                    .presentationDetents([.height(84)])
                }
            }
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.requestAnswers()
            }
        }
    }
}

#Preview {
    WrittenAnswerView()
}
