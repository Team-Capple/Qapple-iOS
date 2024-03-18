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
    
    // TODO: 뒤로가기 제스처 기능 삭제해야댐
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
                        )
                            .disabled(viewModel.answer.isEmpty ? true : false)
                    },
                    backgroundColor: .clear
                )
                
                Spacer()
                    .frame(height: 24)
                
                Text(viewModel.questionText)
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
                    .onChange(of: viewModel.answer) { oldText, newText in
                        
                        // 글자 수 제한 로직
                        if newText.count > viewModel.textLimited {
                            viewModel.answer = oldText
                        }
                        
                        // 폰트 크기 변경 로직
                        switch newText.count {
                        case 0..<30: fontSize = 48
                        case 30..<40: fontSize = 40
                        case 40..<60: fontSize = 32
                        case 60...130: fontSize = 24
                        case 130...: fontSize = 17
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
                    Spacer()
                    Text("\(viewModel.answer.count)/\(viewModel.textLimited)")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 12)
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
            .navigationBarBackButtonHidden()
            .alert("삭제해버린다??", isPresented: $isBackAlertPresented) {
                HStack {
                    Button("취소", role: .cancel, action: {})
                    Button("확인", role: .none, action: {
                        viewModel.resetAnswerInfo()
                        pathModel.paths.removeLast()
                    })
                }
            } message: {
                Text("지금까지 작성한 답변이 사라져요")
            }
            .onAppear {
                Task {
                    await viewModel.requestMainQuestion()
                }
            }
        }
    }
}

#Preview {
    AnswerView(viewModel: .init())
}
