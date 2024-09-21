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
        ZStack {
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
                            .opacity(viewModel.isLoading ? 0 : 1)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(Array(viewModel.myAnswers.enumerated()), id: \.offset) {
                            index,
                            answer in
                            VStack {
                                AnswerCell(
                                    answer: Answer(
                                        id: answer.answerId,
                                        writerId: answer.writerId,
                                        learnerIndex: 0,
                                        content: answer.content,
                                        writingDate: answer.writeAt.ISO8601ToDate,
                                        isMine: false,
                                        isReported: false
                                    ),
                                    seeMoreAction: {
                                        isMyAnswer = .init(answerId: answer.answerId, isMine: true)
                                    }
                                )
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
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.primary)
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
