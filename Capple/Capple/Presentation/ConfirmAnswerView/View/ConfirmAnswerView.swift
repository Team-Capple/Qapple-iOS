//
//  ConfirmAnswerView.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI
import FlexView

struct ConfirmAnswerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: AnswerViewModel
    @State private var isButtonActive = false
    @State private var isPresented = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            CustomNavigationBackButton(buttonType: .arrow)
            
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
            
            Text("키워드")
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(TextLabel.sub3)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 24)
            
            KeywordView(viewModel: viewModel, isPresented: $isPresented)
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 24)
            
            Text("* 내 답변을 표현할 수 있는 키워드를 추가해보세요")
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub3)
                .padding(.horizontal, 24)
            
            Spacer()
            
            ActionButton("완료", isActive: $isButtonActive)
                .padding(.horizontal, 24)
        }
        .background(Background.second)
        //        .toolbar {
        //            ToolbarItem(placement: .topBarLeading) {
        //                Button {
        //                    presentationMode.wrappedValue.dismiss()
        //                } label: {
        //                    Image(systemName: "chevron.left")
        //                        .foregroundStyle(.wh)
        //                        .frame(width: 32, height: 32)
        //                }
        //            }
        //        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isPresented) {
            SearchKeywordView(viewModel: .init())
                .environmentObject(viewModel)
        }
    }
}

// MARK: - KeywordView
private struct KeywordView: View {
    
    @ObservedObject private var viewModel: AnswerViewModel
    @Binding var isPresented: Bool
    
    fileprivate init(viewModel: AnswerViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    
    var body: some View {
        if viewModel.keywords.isEmpty {
            KeywordChoiceChip(buttonType: .addKeyword) {
                isPresented.toggle()
            }
        }
        
        FlexView(data: viewModel.keywords, spacing: 8, alignment: .leading) { keyword in
            keyword == viewModel.keywords.last ?
            KeywordChoiceChip(buttonType: .addKeyword) {
                isPresented.toggle()
            }
            :
            KeywordChoiceChip(keyword.name, buttonType: .label) {
                guard let index = viewModel.keywords.firstIndex(of: keyword) else { return }
                viewModel.keywords.remove(at: index)
            }
        }
    }
}

#Preview {
    ConfirmAnswerView()
        .environmentObject(AnswerViewModel())
}
