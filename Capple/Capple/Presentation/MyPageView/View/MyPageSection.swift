//
//  MyPageSection.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct MyPageSection: View {
    
    let sectionInfo: SectionInfo
    let sectionActions: [() -> Void]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(sectionInfo.sectionTitle)
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 18))
                    .frame(height: 14)
                    .padding(.bottom, 20)
                
                ForEach(sectionInfo.sectionContents.indices, id: \.self) { index in
                    Button {
                        sectionActions[index]()
                    } label: {
                        HStack(spacing: 12) {
                            Image(sectionInfo.sectionIcons[index])
                                .foregroundStyle(TextLabel.main)
                            
                            Text(sectionInfo.sectionContents[index])
                                .foregroundStyle(TextLabel.sub2)
                                .font(Font.pretendard(.medium, size: 16))
                                .frame(height: 12)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                    }
                    
                    Rectangle().frame(height: 1).foregroundStyle(GrayScale.stroke)
                }
            }
        }
        .padding(24)
        .background(Background.first)
    }
}

#Preview {
    MyPageSection(sectionInfo: SectionInfo(
        id: 0,
        sectionTitle: "질문/답변",
        sectionContents: [
            "작성한 답변",
            "좋아요 한 질문",
            "좋아요 한 답변"
        ],
        sectionIcons: [
            "WriteAnswerIcon",
            "LikeQuestionIcon",
            "LikeAnswerIcon"]
    ), sectionActions: [])
}
