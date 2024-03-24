//
//  AnswerCell.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI
import FlexView

struct AnswerCell: View {
    
    var profileName: String
    var profileImage: String?
    var answer: String
    var keywords: [String]
    let seeMoreAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                // 프로필 이미지
                Image(
                    profileImage != nil && !profileImage!.isEmpty ?profileImage! : "profileDummyImage"
                )
                .resizable()
                .frame(width: 28, height: 28)
                
                Spacer()
                    .frame(width: 8)
                
                // 콘텐츠
                //      VStack(alignment: .leading) {
                //        HStack {
                Text(profileName)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.sub2)
                    .frame(height: 10)
                // .padding(.top, 8)
                
                
                Spacer()
                
                // 더보기
                Button {
                    seeMoreAction()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(TextLabel.sub2)
                        .frame(width: 20, height: 20)
                    //              }
                    //        }
                }
            }
            Spacer()
                .frame(height: 8)
            VStack(alignment: .leading){
                
                // 답변
                Text(answer)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                    .frame(height: 12)
                
                // 키워드
                // TODO: 라이브러리 사용해버렸습니다,, 나중에 공부하면서 수정해보기
                FlexView(data: keywords, spacing: 8, alignment: .leading) { keyword in
                    Text("#\(keyword)")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(BrandPink.text)
                        .frame(height: 10)
                }
            }.padding(.leading, 36)
        }
        .padding(24)
        }
    }


#Preview {
    ZStack {
        Color(Background.first)
            .ignoresSafeArea()
        
        AnswerCell(
            profileName: "와플대학",
            answer: "답변입니다.",
            keywords: ["첫번째키워드", "두번째키워드"],
            seeMoreAction: {}
        )
    }
}
