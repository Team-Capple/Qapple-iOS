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
    @State private var isRequestRegisterAnswer = false
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leadingView: {
                    CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.paths.removeLast()
                    }
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
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundStyle(TextLabel.sub3)
                    .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 20)
                
                KeywordView(viewModel: viewModel,
                            isButtonActive: $isButtonActive)
                .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 24)
                
                Text("* 내 답변을 표현할 수 있는 키워드를 추가해보세요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.sub3)
                    .frame(height: 10)
                    .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 12)
                
                Text("** 키워드는 최대 3개까지 추가 가능해요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.sub3)
                    .frame(height: 10)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                ActionButton("답변 등록하기", isActive: $isButtonActive) {
                    isRequestRegisterAnswer.toggle()
                    pathModel.paths.append(.completeAnswer)
                    HapticManager.shared.notification(type: .success)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .animation(.bouncy(duration: 0.3), value: isButtonActive)
                .disabled(isRequestRegisterAnswer)
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
    @State private var isKeywordInputAlertPresented = false
    @State private var keywordInputText = ""
    
    fileprivate init(viewModel: AnswerViewModel, isButtonActive: Binding<Bool>) {
        self.viewModel = viewModel
        self._isButtonActive = isButtonActive
    }
    
    var body: some View {
        Group {
            if viewModel.keywords.count < 1 {
                KeywordChoiceChip(buttonType: .addKeyword) {
                    isKeywordInputAlertPresented.toggle()
                }
            } else if viewModel.keywords.count < 3 {
                FlexView(data: viewModel.flexKeywords, spacing: 8, alignment: .leading) { keyword in
                    keyword == viewModel.flexKeywords.last ?
                    KeywordChoiceChip(buttonType: .addKeyword) {
                        isKeywordInputAlertPresented.toggle()
                    }
                    :
                    KeywordChoiceChip(keyword.name, buttonType: .label) {
                        viewModel.removeKeyword(keyword)
                        isButtonActive = viewModel.keywords.isEmpty ? false : true
                    }
                }
            } else {
                FlexView(data: viewModel.keywords, spacing: 8, alignment: .leading) { keyword in
                    KeywordChoiceChip(keyword.name, buttonType: .label) {
                        viewModel.removeKeyword(keyword)
                        isButtonActive = viewModel.keywords.isEmpty ? false : true
                    }
                }
            }
        }
        .alert("키워드를 입력해주세요", isPresented: $isKeywordInputAlertPresented) {
            TextField("ex) 캐플", text: $keywordInputText)
                .autocorrectionDisabled()
            
            // 띄어쓰기 방지 로직
                .onChange(of: keywordInputText) { _, newValue in
                    if newValue.contains(" ") {
                        keywordInputText = newValue.replacingOccurrences(of: " ", with: "")
                    }
                }
            
            // 최대 8글자 제한 로직
                .onChange(of: keywordInputText) { _, keyword in
                    if keyword.count > 8 {
                        keywordInputText = String(keyword.prefix(8))
                    }
                }
            
            Button("취소", role: .cancel) {
                keywordInputText = ""
            }
            
            Button("추가하기") {
                viewModel.createNewKeyword(keywordInputText)
                isButtonActive = viewModel.keywords.isEmpty ? false : true
                keywordInputText = ""
            }
            .disabled(keywordInputText.isEmpty)
        } message: {
            Text("최대 8글자까지 입력 가능해요")
        }
    }
}

#Preview {
    ConfirmAnswerView(viewModel: .init())
}
