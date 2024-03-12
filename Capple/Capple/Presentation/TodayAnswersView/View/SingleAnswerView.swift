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
            HStack(alignment: .top) { // 이름과 이미지를 가로로 배열하기 위한 HStack 추가
                Image("CappleDefaultProfile") // 여기서 "avatar"는 예시 이미지 이름입니다. 적절한 이미지 이름으로 교체해야 합니다.

                    .foregroundStyle(TextLabel.bk)
                    .frame(width: 28, height: 28)
    
                    .clipShape(Circle())
                Spacer()
                    .frame(width: 8)
                
                VStack(alignment: .leading) { // 세로 스택을 사용해 요소들을 정렬합니다.
                    
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
                        .lineLimit(.max)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                    Spacer()
                        .frame(height: 12)
                    
                    Text(answer.tags?
                           .split(separator: " ")
                           .map { "#\($0)" }
                           .joined(separator: " ") ?? "#tag")
                           .font(.pretendard(.semiBold, size: 14))
                           .foregroundStyle(BrandPink.text)
                   
                    
                    // MARK: - 한톨코드
                    /*
                    FlexView(data: answer.tags ?? "tags", spacing: 8, alignment: .leading) { keyword in
                        Text(keyword)
                            .font(.pretendard(.semiBold, size: 14))
                            .foregroundStyle(BrandPink.text)
                    }
                     */
                    Button {
                        seeMoreAction()
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(TextLabel.sub2)
                            .frame(width: 20, height: 20)
                    }
                    .contextMenu {
                        Button("신고하기") {
                            showingReportSheet = true
                        }
                    }
                   
                    
                }
                
            }.sheet(isPresented: $showingReportSheet) {
                ReportView()
                VStack {
                    Text(answer.tags ?? "tags") .foregroundColor(.gray) // 글자 색상을 회색으로 설정합니다.
                            .font(.caption) // 작은 글자 크기로 설정합니다.
                            
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

    }


/*
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
 */
