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
    var answer: Answer
    
    let seeMoreAction: () -> Void
    
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    var body: some View {
        HStack (alignment: .top){
            Image("CappleDefaultProfile") // 여기서 "avatar"는 예시 이미지 이름입니다. 적절한 이미지 이름으로 교체해야 합니다.
                .foregroundStyle(TextLabel.bk)
                .frame(width: 28, height: 28)
                .clipShape(Circle())
            Spacer()
                .frame(width: 8)
            
            VStack(alignment: .leading) {
                Text(answer.nickname ?? "nickname") // 유저 닉네임 표시합니다.
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(TextLabel.sub2)
                    .frame(height: 10)
                    .padding(.top, 8)
                Spacer()
                    .frame(height: 12)
                
                Text(answer.content ?? "content")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.main)
                
                Spacer()
                    .frame(height: 12)
                HStack {
                    ForEach(answer.tags?.split(separator: " ").map(String.init) ?? [], id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundColor(BrandPink.text)
                        Spacer()
                            .frame(width: 8)
                        
                    }
                }
                
                
                // MARK: - 한톨코드
                /*
                 FlexView(data: answer.tags ?? "tags", spacing: 8, alignment: .leading) { keyword in
                 Text(keyword)
                 .font(.pretendard(.semiBold, size: 14))
                 .foregroundStyle(BrandPink.text)
                 }
                 */
                
                // MARK: - 기존코드
                /*
                 Text(answer.tags?
                 .split(separator: " ")
                 .map { "#\($0)" }
                 .joined(separator: " ") ?? "#tag")
                 .font(.pretendard(.semiBold, size: 14))
                 .foregroundStyle(BrandPink.text)
                 */
                
            }
            .lineLimit(.max)
            .lineSpacing(6)
            .multilineTextAlignment(.leading)
        
            Spacer()
                    Button {
                        seeMoreAction()
                        showingReportSheet = true

                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(TextLabel.sub2)
                            .frame(width: 20, height: 20)
                    }
                
            }
            .sheet(isPresented: $showingReportSheet) {
                ReportView()
            }
             
        }
        

        /*
         HStack { // 좋아요와 댓글 아이콘을 가로로 나열합니다.
         Image(systemName: "heart.fill") // 좋아요 아이콘을 표시합니다.
         .foregroundColor(.red) // 아이콘 색상을 빨간색으로 설정합니다.
         Text(answer.content ?? "content") // 좋아요 수를 표시합니다.
         .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
         .font(.subheadline) // 약간 작은 글자 크기로 설정합니다.
         }
         */
        
    }


struct SingleAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleAnswerView(answer: Answer(profileImage: "CappleDefaultProfile", nickname: "user", content: "This is a sample answer.", tags: "tag tag2222222 tag"), seeMoreAction: {})
    }
}
