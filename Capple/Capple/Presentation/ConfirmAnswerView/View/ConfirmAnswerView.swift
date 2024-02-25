//
//  ConfirmAnswerView.swift
//  Capple
//
//  Created by 김민준 on 2/25/24.
//

import SwiftUI

struct ConfirmAnswerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: ConfirmAnswerViewModel
    @State private var isButtonActive = false
    
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
                        .frame(height: 24)
                    
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
                    
                    Spacer()
                    
                    ActionButton("완료", isActive: $isButtonActive)
                        .padding(.horizontal, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.wh)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ConfirmAnswerView(viewModel: .init(answer: """
생각이 깊고 마음이 따뜻한 사람이 좋은 것 같아요. 함께 프로젝트를 진행하며 믿고 의지할 수 있잖아요 그렇죠? 저는 그렇게 생각하는데 다른 사람들은 모르겠네요 ㅎㅎ
"""))
}
