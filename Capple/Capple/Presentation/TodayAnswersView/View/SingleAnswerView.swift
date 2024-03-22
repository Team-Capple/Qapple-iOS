//
//  Answer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI
import FlexView


// 하나의 질문을 보여주는 뷰를 정의합니다.
struct SingleAnswerView: View {
    
    @State private var showReportButton = false // Report 버튼 표시 여부
    
    var answer: ServerResponse.Answers.AnswersInfos
    let seeMoreAction: () -> Void
    
    var body: some View {
        
        VStack {// MARK: - 전체 vstack
            
            // MARK: - 프로필이미지 + 닉네임+버튼 hstack
            HStack {
                // MARK: - 프로필이미지
                
                Image(answer.profileImage != nil && !answer.profileImage!.isEmpty ? answer.profileImage! : "profileDummyImage")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                
                // MARK: - 닉네임 + 버튼 hstack
                Text(answer.nickname ?? "nickname")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.sub2)
                    .frame(height: 10)
                
                Spacer()
                
                Button {
                    seeMoreAction()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(TextLabel.sub2)
                        .frame(width: 20, height: 20)
                }
            }
            
            
            Spacer().frame(height: 8)
            // MARK: - 내용+태그  vstack
            VStack {
                
                // MARK: - 내용 hstack
                HStack(alignment: .top) {
                    
                    Text(answer.content ?? "content")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.main)
                        .lineLimit(nil)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .frame(height: 11)
                        .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
                }
                
                Spacer().frame(height: 12)
                
                // MARK: - 태그 hstack
                HStack {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(answer.tags?.split(separator: " ").map(String.init) ?? [], id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.pretendard(.semiBold, size: 14))
                                .foregroundColor(BrandPink.text)
                                .frame(height: 10)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.leading, 36)
        }
        .padding(24)
    }
}
