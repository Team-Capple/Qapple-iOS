//
//  Answer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct SingleAnswerView: View {
    var answer: Answer
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // 세로 스택을 사용해 요소들을 정렬합니다.
            
            HStack { // 이름과 이미지를 가로로 배열하기 위한 HStack 추가
                            Image(systemName: "person.crop.circle.fill") // 여기서 "avatar"는 예시 이미지 이름입니다. 적절한 이미지 이름으로 교체해야 합니다.
                                .resizable() // 이미지의 크기를 조절할 수 있도록 설정합니다.
                                .aspectRatio(contentMode: .fill) // 이미지의 비율을 유지하며 채웁니다.
                                .frame(width: 50, height: 50) // 이미지의 크기를 설정합니다.
                                .clipShape(Circle()) // 이미지를 원형으로 자릅니다.
                                .padding(.trailing, 10) // 이미지와 이름 사이의 간격을 설정합니다.
               
                Text(answer.nickname ?? "nickname") // 유저 닉네임 표시합니다.
                                .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
                                .font(.title3) // 글자 크기를 설정합니다.
                                .fontWeight(.bold) // 글자 두께를 굵게 설정합니다.
                VStack {
                    Text(answer.tags ?? "tags") .foregroundColor(.gray) // 글자 색상을 회색으로 설정합니다.
                            .font(.caption) // 작은 글자 크기로 설정합니다.
                            
                }
            }
            Divider().background(Color.gray) // 구분선을 추가합니다.
            HStack { // 좋아요와 댓글 아이콘을 가로로 나열합니다.
                Image(systemName: "heart.fill") // 좋아요 아이콘을 표시합니다.
                    .foregroundColor(.red) // 아이콘 색상을 빨간색으로 설정합니다.
                Text(answer.content ?? "content") // 좋아요 수를 표시합니다.
                    .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
                    .font(.subheadline) // 약간 작은 글자 크기로 설정합니다.
            }
        }
        .padding() // 내부 요소와의 간격을 설정합니다.
        .background(Color.gray.opacity(0.2)) // 배경색을 설정하고 투명도를 조절합니다.
        .cornerRadius(10) // 모서리를 둥글게 처리합니다.
        .padding(.horizontal) // 좌우 간격을 설정합니다.
    }
}

#Preview {
    SingleAnswerView(
        answer: .init(
            id: 0,
            name: "",
            content: "",
            tags: [],
            likes: 0
        )
    )
}
