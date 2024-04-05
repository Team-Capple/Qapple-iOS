//
//  WrittenAnswerView.swift
//  Qapple
//
//  Created by 김민준 on 4/2/24.
//

import SwiftUI

struct WrittenAnswerView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    @State private var isBottomSheetPresented = false
    
    let dummyAnswers: [ServerResponse.Answers.AnswersInfos] = [
        .init(
            profileImage: nil,
            nickname: "한톨",
            content: "답변1",
            tags: "태그1 태그2 태그3 태그4"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavigationBar(
                leadingView:{
                    CustomNavigationBackButton(buttonType: .arrow) {
                        pathModel.paths.removeLast()
                    }
                },
                principalView: {
                    Text("작성한 답변")
                        .font(Font.pretendard(.semiBold, size: 15))
                        .foregroundStyle(TextLabel.main)
                },
                trailingView: {
                    
                },
                backgroundColor: .clear
            )
            
            Spacer()
            
            HStack {
                Spacer()
                Text("이후에 업데이트 될 기능이에요")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.sub3)
                Spacer()
            }
            
            Spacer()
            
            // TODO: 추후 내가 작성한 답변 기능 생기면 업데이트
//            ScrollView(.vertical, showsIndicators: false) {
//                
//                // TODO: API를 통해 내가 작성한 답변 불러오기
//                ForEach(Array(dummyAnswers.enumerated()), id: \.offset) { index, answer in
//                    LazyVStack{
//                        SingleAnswerView(answer: answer){
//                            isBottomSheetPresented.toggle()
//                        }
//                        .sheet(isPresented: $isBottomSheetPresented) {
//                            SeeMoreView(answerType: .mine, isBottomSheetPresented: $isBottomSheetPresented)
//                                .presentationDetents([.height(84)])
//                        }
//                        Separator()
//                            .padding(.leading, 24)
//                    }
//                }
//            }
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    WrittenAnswerView()
}
