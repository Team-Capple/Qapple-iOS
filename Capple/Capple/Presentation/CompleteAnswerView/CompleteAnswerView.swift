//
//  CompleteAnswerView.swift
//  Capple
//
//  Created by 김민준 on 3/25/24.
//

import SwiftUI

struct CompleteAnswerView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: AnswerViewModel
    
    @State private var isRegisterAnswerFailed = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: {},
                principalView: {},
                trailingView: {},
                backgroundColor: Background.first)
            
            Spacer()
                .frame(height: 32)
            
            HStack {
                Text("답변 등록이 완료됐어요!\n이제 다른 답변을 확인해볼까요?")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 24))
                    .lineSpacing(6)
                
                Spacer()
            }
            
            Spacer()
            
            Image(.questionComplete)
                .resizable()
                .frame(width: 240, height: 240)
                .padding(.bottom, 48)
            
            Spacer()
            
            ActionButton("확인", isActive: .constant(true)) {
                Task {
                    do {
                        try await viewModel.requestRegisterAnswer()
                        pathModel.paths.removeAll()
                        pathModel.paths.append(
                            .todayAnswer(
                                questionId: viewModel.questionId,
                                questionContent: viewModel.questionContent
                            )
                        )
                        viewModel.resetAnswerInfo()
                    } catch {
                        isRegisterAnswerFailed.toggle()
                    }
                }
            }
            .padding(.bottom, 16)
            .alert("답변 등록에 실패했습니다.", isPresented: $isRegisterAnswerFailed) {
                Button("확인", role: .none) {}
            } message: {
                Text("다시 한번 시도해주세요.")
            }
        }
        .padding(.horizontal, 24)
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .popGestureDisabled()
    }
}

#Preview {
    CompleteAnswerView(viewModel: .init())
        .environmentObject(PathModel())
}
