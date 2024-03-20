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
   // @ObservedObject private var viewModel: TodayAnswersViewModel
    
    var answer: ServerResponse.Answers.AnswersInfos
   
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showReportButton = false // Report 버튼 표시 여부
 //   @ObservedObject var sharedData = SharedData()
    
    let seeMoreAction: () -> Void
  //  let seeMoreReport: () -> CGPoint
    
  //  @State private var showingReportSheet = false // NewReportButtonView 표시 여부
  //  @State private var innerShowingReportSheet = false
  //  @State private var reportButtonPosition: CGPoint? = nil // Report 버튼의 위치
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 8) {
                    VStack{
                        Image(answer.profileImage != nil && !answer.profileImage!.isEmpty ? answer.profileImage! : "profileDummyImage")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                    }
                    VStack{
                        VStack(alignment: .leading){
                            HStack (alignment: .center){
                                HStack{
                                    Text(answer.nickname ?? "nickname")
                                        .font(.pretendard(.semiBold, size: 14))
                                        .foregroundStyle(TextLabel.sub2)
                                        .frame(height: 10)
                                    
                                    
                                    Spacer()
                                    
                                    Button {
                                        //showingReportSheet = true
                                        seeMoreAction()
                                        
                                        
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(TextLabel.sub2)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 8)
                        
                        VStack(alignment: .leading) {
                               Text(answer.content ?? "content")
                                   .font(.pretendard(.medium, size: 16))
                                   .foregroundStyle(TextLabel.main)
                                   .lineLimit(nil)
                                   .lineSpacing(6)
                                   .multilineTextAlignment(.leading)
                                   .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬

                            Spacer()
                                .frame(height: 12)

                               HStack(alignment: .top, spacing: 8) {
                                   ForEach(answer.tags?.split(separator: " ").map(String.init) ?? [], id: \.self) { tag in
                                       Text("#\(tag)")
                                           .font(.pretendard(.semiBold, size: 14))
                                           .foregroundColor(BrandPink.text)
                                   }
                               }
                               .frame( alignment: .leading)
                           }
                      //  Spacer()
                           
                    }
                 //   .frame(maxWidth: .infinity, alignment: .leading)
                    }
                .padding(24)
                
               
     //           }
     
            
                
              
                /*
                if showingReportSheet && !innerShowingReportSheet {
                    NewReportButtonView()
                        .offset(x: reportButtonPosition?.x ?? 0, y: reportButtonPosition?.y ?? 0)
                    // 필요한 위치 조정
                        .onTapGesture {
                            self.innerShowingReportSheet = true
                        }
                }
                 */
            }
           
    }
        /*
            .onTapGesture {
                self.innerShowingReportSheet = true
                
            }
         */
  //  }

            /*
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
                               self.showingReportSheet = true
                             
                               self.reportButtonPosition = seeMoreReport()
                          
                            print("showingReportSheet",sharedData.showingReportSheet)
                            print("innerShowingReportSheet", sharedData.innerShowingReportSheet)
                            print("reportButtonPosition", sharedData.reportButtonPosition ?? CGPoint(x: 0, y: 0))
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(TextLabel.sub2)
                                .frame(width: 20, height: 20)
                        }
                    }
                    /*
                    .overlay(
                        
                        sharedData.reportButtonPosition.map { position in
                            NewReportButtonView()
                                .position(position)
                        }
                    )
                    .animation(.default, value: showReportButton)
                    .onTapGesture {
                        self.innerShowingReportSheet = true
                        
                    }
                    */
                }.onTapGesture {
                    self.innerShowingReportSheet = false
                }
                
                
            }*/
        
        
  //  }
// }

/*
        
// SingleAnswerView 미리보기 정의
struct SingleAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        // 가짜 PresentationMode 생성
        let fakePresentationMode = Binding.constant(PresentationMode)
        // SingleAnswerView에 가짜 PresentationMode 전달
        SingleAnswerView(
            answer: Answer(),
            presentationMode: PresentationMode()
            seeMoreAction: {},
            seeMoreReport: { return CGPoint(x: 0, y: 0) }
        )
    }
}

*/
