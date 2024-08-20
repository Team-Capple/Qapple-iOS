//
//  CommentCell.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentCell: View {
    @State private var likesBtn: Bool = false
    
    @State private var hOffset: CGFloat = 0
    @State private var anchor: CGFloat = 0
    @State private var isCellToggled: Bool = false
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let anchorWidth: CGFloat = 73
    
    let isMine: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 73)
            
            content
                .frame(width: screenWidth)
            
            if isMine {
                deleteBtn
            } else {
                reportBtn
            }
            
        }
        .offset(x: hOffset)
        .animation(.easeInOut, value: hOffset)
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                hOffset = anchor + value.translation.width
                
                if anchor < 0 {
                    isCellToggled = hOffset < -screenWidth / 3 + screenWidth / 15
                } else {
                    isCellToggled = hOffset < -screenWidth / 15
                }
            }
            .onEnded { value in
                if isCellToggled {
                    anchor = -anchorWidth
                } else {
                    anchor = 0
                }
                hOffset = anchor
            }
    }
    
    private var content: some View {
        HStack(alignment: .top, spacing: 13) {
            // 사용자 이미지
            Circle()
                .frame(width: 28)
                .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 10) {
                    // 사용자 이름
                    Text("아무개 2")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(.icon)
                    
                    // TODO: Pretendard-light 폰트 없음
                    // 댓글 timestamp
                    Text("1시간 전")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(.disable)
                }
                
                // 댓글 내용
                Text("이말 완전 인정 이말 완전 인정\n\n")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.main)
            }
            .padding(.vertical, 16)
            
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
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .background(Color.bk)
        .gesture(drag)
    }
    
    private var deleteBtn: some View {
        Button {
            
        } label: {
            ZStack {
                Color.delete
                
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.wh)
            }
        }
        .frame(width: 73)
    }
    
    private var reportBtn: some View {
        Button {
            
        } label: {
            ZStack {
                Color.report
                
                Image(systemName: "light.beacon.min")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.wh)
            }
        }
        .frame(width: 73)
    }
}

#Preview {
    VStack {
        CommentCell(isMine: true)
        CommentCell(isMine: false)
    }
}
