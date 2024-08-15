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
    
    var answer: ServerResponse.Answers.AnswersInfos
    let isReported: Bool
    let seeMoreAction: () -> Void
    
    var body: some View {
        
        if isReported {
            HStack {
                VStack {
                    Text("신고되어 내용을 검토 중인 답변입니다.")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.sub3)
                }
                
                Spacer()
            }
            .padding(24)
        } else {
            VStack {// MARK: - 전체 vstack
                
                // MARK: - 프로필이미지 + 닉네임+버튼 hstack
                HStack {
                    // MARK: - 프로필이미지
                    
                    Image(answer.profileImage != nil && !answer.profileImage!.isEmpty ? answer.profileImage! : "profileDummyImage")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                    
                    // MARK: - 닉네임 + 버튼 hstack
                    Text(answer.nickname)
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
                        
                        Text(answer.content)
                            .font(.pretendard(.medium, size: 16))
                            .foregroundStyle(TextLabel.main)
                            .lineSpacing(6)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
                    }
                    
                    Spacer().frame(height: 12)
                    
                    // MARK: - 태그 hstack  TODO 리스트
                    HStack {
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(answer.tags.split(separator: " ").map(String.init), id: \.self) { tag in
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
}

#Preview {
    SingleAnswerView(
        answer: .init(
            answerId: 1,
            profileImage: nil,
            nickname: "한톨테스트",
            content: "답변입니다.",
            tags: "태그1 태그2 태그3 태그4",
            isMyAnswer: true,
            isReported: false,
            
            isLike: true,
            likeCount: 32,
            commentCount: 32,
            writingDate: Date()
        ),
        isReported: false,
        seeMoreAction: {}
    )
}
