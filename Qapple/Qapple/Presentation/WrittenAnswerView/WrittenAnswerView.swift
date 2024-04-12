//
//  WrittenAnswerView.swift
//  Qapple
//
//  Created by 김민준 on 4/2/24.
//

import SwiftUI

struct WrittenAnswerView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var viewModel: WrittenAnswerViewModel = .init()
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                leadingView:{
                    CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.paths.removeLast()
                    }
                },
                principalView: {
                    Text("작성한 답변")
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {
                    
                },
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
                        LazyVStack {
                            AnswerCell(
                                profileName: answer.nickname,
                                answer: answer.content,
                                keywords: answer.tags.splitTag
                            ) {
                                isBottomSheetPresented.toggle()
                            }
                            .sheet(isPresented: $isBottomSheetPresented) {
                                SeeMoreView(answerType: .mine, isBottomSheetPresented: $isBottomSheetPresented)
                                    .presentationDetents([.height(84)])
                            }
                            Separator()
                                .padding(.leading, 24)
                        }
                    }
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
