//
//  AnswerCell.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI
import FlexView

struct AnswerCell: View {
    
    var profileImageText = "튼"
    var profileName = "튼튼한 당근"
    
    var answer = "생각이 깊고 마음이 따뜻한 사람이 좋은 것 같아요. 함께 프로젝트를 진행하며 믿고 의지할 수 있자나요 생각이 깊고 마음이 따뜻한 사람이 좋은 것 같아요."
    
    var keywords = ["와플유니버시티", "당근맨", "무자비", "잔망루피", "애플", "아카데미", "디벨로퍼", "디자이너"]
    
    var likeCount = 32
    
    @State var isLike = false
    @State var likeColor = GrayScale.secondaryButton
    
    let seeMoreAction: () -> Void
    
    var body: some View {
        
        /// 프로필
        HStack(alignment: .top) {
            Text(profileImageText)
                .font(.pretendard(.semiBold, size: 18))
                .foregroundStyle(TextLabel.bk)
                .frame(width: 28, height: 28)
                .background(BrandPink.profile)
                .clipShape(Circle())
            
            Spacer()
                .frame(width: 8)
            
            /// 콘텐츠
            VStack(alignment: .leading) {
                Text(profileName)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.sub2)
                    .frame(height: 10)
                    .padding(.top, 8)
                
                Spacer()
                    .frame(height: 12)
                
                Text(answer)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                    .lineLimit(.max)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                    .frame(height: 12)
                
                /// 라이브러리 사용해버렸습니다,, 나중에 공부하면서 수정해보기
                FlexView(data: keywords, spacing: 8, alignment: .leading) { keyword in
                    Text("#\(keyword)")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(BrandPink.text)
                }
                
                Spacer()
                    .frame(height: 16)
                
                Button {
                    isLike.toggle()
                    // TODO: - 좋아요 탭 기능 구현
                } label: {
                    HStack(spacing: 6) {
                        Image(isLike ? .heartActive : .heart)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isLike ? BrandPink.button : GrayScale.secondaryButton)
                        
                        Text("\(likeCount)")
                            .font(.pretendard(.medium, size: 15))
                            .foregroundStyle(TextLabel.sub3)
                    }
                }
            }
            
            /// 아이콘
            Button {
                seeMoreAction()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(TextLabel.sub2)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

#Preview {
    ZStack {
        Color(Background.first)
            .ignoresSafeArea()
        
        AnswerCell(seeMoreAction: {})
    }
}
