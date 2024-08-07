//
//  CommentCell.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentCell: View {
    @State private var likesBtn: Bool = false
    var body: some View {
        HStack(spacing: 13) {
            // 사용자 이미지
            Circle()
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    // 사용자 이름
                    Text("아무개 2")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(.icon)
                    
                    // 댓글 timestamp
                    Text("1시간 전")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(.disable)
                }
                
                // 댓글 내용
                Text("이말 완전 인정 ㅋ")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.main)
            }
            
            Spacer()
            
            
            VStack {
                // 댓글 좋아요 버튼
                Button {
                    self.likesBtn.toggle()
                } label: {
                    Image(systemName: self.likesBtn ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundStyle(self.likesBtn ? .button : .sub4)
                }
                
                // 댓글 좋아요 갯수
                Text("32")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.sub3)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 70)
        .background(Color.bk)
    }
}

#Preview {
    CommentCell()
}
