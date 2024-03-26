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
    @State private var isAnonymityAlertPresented = false
    
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
                            color: viewModel.answer.isEmpty ?
                            TextLabel.disable : BrandPink.text,
                            buttonType: .next(pathType: .confirmAnswer)
                        ) {
                            viewModel.questionId = questionId
                            viewModel.questionContent = questionContent
                        }
                        .disabled(viewModel.answer.isEmpty ? true : false)
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
                        Text("자유롭게 생각을\n작성해주세요")
                            .foregroundStyle(TextLabel.placeholder)
                            .padding(.horizontal, 24)
                    }
                    
                    TextField(text: $viewModel.answer, axis: .vertical) {
                        Color.clear
                    }
                    .foregroundStyle(.wh)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal, 24)
                    .autocorrectionDisabled()
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
                        isAnonymityAlertPresented.toggle()
                    } label: {
                        Text("익명이 보장되나요?")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundStyle(BrandPink.text)
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
            .onTapGesture {
                isTextFieldFocused = false
            }
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
            .alert("익명이 보장되나요?", isPresented: $isAnonymityAlertPresented) {
                Button("확인", role: .none) {}
            } message: {
                Text("100% 익명입니다.")
            }

        }
        .popGestureDisabled()
    }
}

#Preview {
    AnswerView(viewModel: .init(), questionId: 1, questionContent: "메인 질문 입니당!")
}
