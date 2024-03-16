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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showReportButton = false // Report 버튼 표시 여부
    @ObservedObject var sharedData = SharedData()
    
    let seeMoreAction: () -> Void
    let seeMoreReport: () -> CGPoint
    
    
    var body: some View {
        ZStack{
            if !sharedData.innerShowingReportSheet  {
                ZStack {
                    
                    HStack (alignment: .top){
                        Image(answer.profileImage ?? "CappleDefaultProfile")
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
                        }
                        .lineLimit(.max)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        
                        Button {
                            sharedData.showingReportSheet = true
                            print("showingReportSheet",sharedData.showingReportSheet)
                            print("innerShowingReportSheet", sharedData.innerShowingReportSheet)
                            print("reportButtonPosition", sharedData.reportButtonPosition!)
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(TextLabel.sub2)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                
                
                
            }
            else if sharedData.showingReportSheet && !sharedData.innerShowingReportSheet {
                ZStack{
                    
                    Color.black.opacity(0.5) // 반투명 배경
                        .ignoresSafeArea()
                    
                    HStack (alignment: .top){
                        Image(answer.profileImage ?? "CappleDefaultProfile")
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
                        }
                        .lineLimit(.max)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Button {
                            // self.reportButtonPosition = CGPoint(x: geometry.frame(in: .global).minX, y: geometry.frame(in: .global).minY)
                            sharedData.showingReportSheet = true
                            print("showingReportSheet",sharedData.showingReportSheet)
                            print("innerShowingReportSheet", sharedData.innerShowingReportSheet)
                            print("reportButtonPosition", sharedData.reportButtonPosition ?? CGPoint(x: 0, y: 0))
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(TextLabel.sub2)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .overlay(
                        sharedData.reportButtonPosition.map { position in
                            NewReportView()
                                .position(position)
                        }
                    )

                    
                    
                    
                    //.offset(x: sharedData.offset + 40 , y: sharedData.offset )
                    //    .offset(x: seeMoreReport().x , y: seeMoreReport().y )
                    .animation(.default, value: showReportButton)
                    .onTapGesture {
                        sharedData.innerShowingReportSheet = true
                    }
                }.onTapGesture {
                    sharedData.innerShowingReportSheet = false
                }
                
            }
        }
        
    }
}
        
    

/*
struct SingleAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleAnswerView(answer: Answer(profileImage: "CappleDefaultProfile", nickname: "user", content: "This is a sample answer.", tags: "tag tag2222222 tag"), seeMoreAction: {}, seeMoreReport: {return CGPoint(10)})
    }
}

*/
