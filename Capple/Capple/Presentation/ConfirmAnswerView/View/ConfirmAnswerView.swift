//
//  ConfirmAnswerView.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI
import FlexView

struct ConfirmAnswerView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject var viewModel: AnswerViewModel
    @State private var isButtonActive = false
    
    var body: some View {
        
        VStack {
            CustomNavigationBar(
                leadingView: {
                    CustomNavigationBackButton(buttonType: .arrow)
                },
                principalView: {},
                trailingView: {},
                backgroundColor: .clear
            )
            
            Spacer()
                .frame(height: 24)
            
            Text(viewModel.answerText)
                .font(.pretendard(.bold, size: 23))
                .foregroundStyle(BrandPink.subText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.bottom, 32)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 24)
            
            VStack(alignment: .leading) {
                Text("키워드")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.sub3)
                    .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 24)
                
                KeywordView(viewModel: viewModel,
                            isButtonActive: $isButtonActive)
                    .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 24)
                
                Text("* 내 답변을 표현할 수 있는 키워드를 추가해보세요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.sub3)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                ActionButton("완료", isActive: $isButtonActive) {
                    // TODO: 완료 후 답변 자세히 보기 화면으로 이동
                    pathModel.paths.removeAll()
                }
                    .padding(.horizontal, 24)
                    .animation(.bouncy(duration: 0.3), value: isButtonActive)
            }
        }
        .background(Background.second)
        .navigationBarBackButtonHidden()
        .onAppear {
            isButtonActive = viewModel.keywords.isEmpty ? false : true
        }
    }
}

// MARK: - KeywordView
private struct KeywordView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject private var viewModel: AnswerViewModel
    @Binding var isButtonActive: Bool
    
    fileprivate init(viewModel: AnswerViewModel, isButtonActive: Binding<Bool>) {
        self.viewModel = viewModel
        self._isButtonActive = isButtonActive
    }
    
    var body: some View {
        if viewModel.keywords.count < 1 {
            KeywordChoiceChip(buttonType: .addKeyword) {
                pathModel.paths.append(.searchKeyword)
            }
        } else {
            FlexView(data: viewModel.flexKeywords, spacing: 8, alignment: .leading) { keyword in
                
                keyword == viewModel.flexKeywords.last ?
                KeywordChoiceChip(buttonType: .addKeyword) {
                    // TODO: 키워드 입력 창 띄우기
                }
                :
                KeywordChoiceChip(keyword.name, buttonType: .label) {
                    viewModel.removeKeyword(keyword)
                    isButtonActive = viewModel.keywords.isEmpty ? false : true
                }
            }
        }
    }
}

#Preview {
    ConfirmAnswerView(viewModel: .init())
}
