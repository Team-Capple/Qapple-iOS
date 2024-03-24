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
    @State private var isRegisterAnswerFailed = false
    
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
                
                ActionButton("완료", isActive: $isButtonActive) {
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
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .animation(.bouncy(duration: 0.3), value: isButtonActive)
                .alert("답변 등록에 실패했습니다.", isPresented: $isRegisterAnswerFailed) {
                    Button("확인", role: .none) {}
                } message: {
                    Text("다시 한번 시도해주세요.")
                }
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
    @State private var isKeywordCountAlertPresented = false
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
            } else {
                FlexView(data: viewModel.flexKeywords, spacing: 8, alignment: .leading) { keyword in
                    
                    keyword == viewModel.flexKeywords.last ?
                    KeywordChoiceChip(buttonType: .addKeyword) {
                        
                        // 만약 3개 이상 생성 시 키워드 생성 제한
                        if viewModel.keywords.count >= 3 {
                            isKeywordCountAlertPresented.toggle()
                            return
                        }
                        
                        isKeywordInputAlertPresented.toggle()
                    }
                    :
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
                .onChange(of: keywordInputText) { _, newValue in
                    if newValue.contains(" ") {
                        keywordInputText = newValue.replacingOccurrences(of: " ", with: "")
                    }
                }
            
            Button("취소", role: .cancel) {
                keywordInputText = ""
            }
            
            Button("확인") {
                viewModel.createNewKeyword(keywordInputText)
                isButtonActive = viewModel.keywords.isEmpty ? false : true
                keywordInputText = ""
            }
        }
        .alert("키워드는 최대 3개까지 추가 가능해요", isPresented: $isKeywordCountAlertPresented) {
            Button("확인", role: .none) {}
        }
    }
}

#Preview {
    ConfirmAnswerView(viewModel: .init())
}
