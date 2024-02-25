//
//  AnswerConfirmView.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI

struct AnswerConfirmView: View {
    
    @StateObject var viewModel: AnswerConfirmViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(Background.second)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
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
                        .frame(height: 56)
                    
                    Text("키워드")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 24)
                    
                    KeywordChoiceChip(buttonType: .addKeyword)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 24)
                    
                    Text("* 내 답변을 표현할 수 있는 키워드를 추가해보세요")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .padding(.horizontal, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: - Navigation/뒤로가기
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.wh)
                    }
                }
            }
        }
    }
}

#Preview {
    AnswerConfirmView(viewModel: .init())
}
