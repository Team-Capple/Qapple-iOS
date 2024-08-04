//
//  AnswerView.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI

struct AnswerView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: AnswerViewModel
    @State private var fontSize: CGFloat = 48
    @State private var isBackAlertPresented = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var isAnonymitySheetPresented = false
    
    let questionId: Int
    let questionContent: String
    
    var body: some View {
        
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(
                    leadingView: {
                        CustomNavigationBackButton(buttonType: .xmark) {
                            isBackAlertPresented.toggle()
                        }
                    },
                    principalView: {},
                    trailingView: {
                        CustomNavigationTextButton(
                            title: "다음",
                            color: viewModel.answer.count < 3 ?
                            TextLabel.disable : BrandPink.text,
                            buttonType: .next(pathType: .confirmAnswer)
                        ) {
                            viewModel.questionId = questionId
                            viewModel.questionContent = questionContent
                        }
                        .disabled(viewModel.answer.count < 3)
                    },
                    backgroundColor: .clear
                )
                
                Spacer()
                    .frame(height: 24)
                
                Text(viewModel.questionText(questionContent))
                    .font(.pretendard(.bold, size: 23))
                    .foregroundStyle(BrandPink.subText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                ZStack {
                    if viewModel.answer.isEmpty {
                        VStack(spacing: 16) {
                            Text("자유롭게 생각을\n작성해주세요")
                                .font(.pretendard(.semiBold, size: 48))
                                .foregroundStyle(TextLabel.placeholder)
                                .padding(.horizontal, 24)
                            
                            Text("* 부적절하거나 불쾌감을 줄 수 있는\n컨텐츠는 제재를 받을 수 있어요")
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(TextLabel.placeholder)
                                .padding(.horizontal, 24)
                                .lineSpacing(6)
                        }
                    }
                    
                    TextField(text: $viewModel.answer, axis: .vertical) {
                        Color.clear
                    }
                    .foregroundStyle(.wh)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal, 24)
                    .autocorrectionDisabled()
                    .onTapGesture {
                        isTextFieldFocused = true
                    }
                    .onChange(of: viewModel.answer) { oldText, newText in
                        
                        // 글자 수 제한 로직
                        if newText.count > viewModel.textLimited {
                            viewModel.answer = oldText
                        }
                        
                        // 폰트 크기 변경 로직
                        switch newText.count {
                        case 0..<20: fontSize = 48
                        case 20..<32: fontSize = 40
                        case 32..<60: fontSize = 32
                        case 60...100: fontSize = 24
                        case 100...: fontSize = 17
                        default: break
                        }
                    }
                }
                .font(.pretendard(.semiBold, size: fontSize))
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundStyle(Color.clear)
                
                HStack {
                    Button {
                        isAnonymitySheetPresented.toggle()
                    } label: {
                        Text("익명이 보장되나요?")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundStyle(BrandPink.text)
                    }
                    .sheet(isPresented: $isAnonymitySheetPresented) {
                        AnonymityNoticeView(isAnonymitySheetPresented: $isAnonymitySheetPresented)
                            .presentationDetents([.height(560)])
                    }
                    
                    Spacer()
                    
                    Text("\(viewModel.answer.count)/\(viewModel.textLimited)")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            }
            .navigationBarBackButtonHidden()
            .alert("정말 그만두시겠어요?", isPresented: $isBackAlertPresented) {
                HStack {
                    Button("취소", role: .cancel) {}
                    Button("그만두기", role: .none) {
                        viewModel.resetAnswerInfo()
                        pathModel.paths.removeLast()
                    }
                }
            } message: {
                Text("지금까지 작성한 답변이 사라져요")
            }
        }
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .popGestureDisabled()
    }
}

#Preview {
    AnswerView(viewModel: .init(), questionId: 1, questionContent: "메인 질문 입니당!")
}
