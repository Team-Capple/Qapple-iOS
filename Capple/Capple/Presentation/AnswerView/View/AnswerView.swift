//
//  AnswerView.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI

struct AnswerView: View {
    
    @StateObject var viewModel: AnswerViewModel
    @State private var fontSize: CGFloat = 48
    @State private var isPresented = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        VStack {
            
            Spacer()
                .frame(height: 24)
            
            Text(viewModel.questionText)
                .font(.pretendard(.bold, size: 23))
                .foregroundStyle(BrandPink.subText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.bottom, 32)
            
            Spacer()
            
            ZStack {
                if viewModel.answer.isEmpty {
                    Text("자유롭게 생각을\n작성해주세요")
                        .foregroundStyle(TextLabel.placeholder)
                }
                
                TextField(text: $viewModel.answer, axis: .vertical) {
                    Color.clear
                }
                .foregroundStyle(.wh)
                .focused($isTextFieldFocused)
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
            }
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 24)
        .background(Background.second)
        .onTapGesture {
            isTextFieldFocused = false
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    // TODO: - Navigation/답변하기 화면 닫기
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.wh)
                }
            }
            
            ToolbarItem {
                Button {
                    isPresented.toggle()
                } label: {
                    Text("다음")
                        .font(
                            .pretendard(viewModel.answer.isEmpty ?
                                .medium : .semiBold, size: 17)
                        )
                        .foregroundStyle(
                            viewModel.answer.isEmpty ?
                            TextLabel.disable : BrandPink.text
                        )
                }
                .disabled(viewModel.answer.isEmpty ? true : false)
            }
        }
        .navigationDestination(isPresented: $isPresented) {
            ConfirmAnswerView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    AnswerView(viewModel: .init())
}
