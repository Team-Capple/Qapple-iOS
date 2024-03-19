//
//  TodayAnswer.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//

import Foundation
import SwiftUI
struct TodayAnswerView: View {
    @EnvironmentObject var pathModel: PathModel
    @Binding var tab: Tab
    var questionContent: String = "완전기본값제공" // 여기에 기본값을 제공합니다.
    var questionId: Int =  1// 여기에 기본값을 제공합니다.
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    @State private var isBottomSheetPresented = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
  
    
    
    init(questionId: Int, tab: Binding<Tab>, questionContent: String) {
        self.viewModel = TodayAnswersViewModel(questionId: questionId )
        self._tab = tab
        self.questionContent = questionContent
        self.questionId = questionId
    }

     
    var body: some View {
   //     @ObservedObject var sharedData = SharedData()
        
        VStack(alignment: .leading) {
            CustomNavigationView()
           // KeywordScrollView(viewModel: viewModel)
            Spacer()
                .frame(height: 16)
           
            FloatingQuestionCard(questionContent: questionContent ,tab:$tab, viewModel: viewModel, questionId: questionId)
            Spacer()
                .frame(height: 32)
            AnswerScrollView(viewModel: viewModel, tab: $tab, isBottomSheetPresented: $isBottomSheetPresented)
                
        }
        
        .navigationBarBackButtonHidden()
        .background(Color.Background.first)
    }
}

// MARK: - 커스텀 네비게이션
private struct CustomNavigationView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        CustomNavigationBar(
            leadingView:{
                CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.paths.removeLast()
                }
            },
            principalView: {
                Text("오늘의 답변")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main)
            },
            trailingView: {
                
            },
            backgroundColor: .clear
        )
    }
}

// MARK: - 키워드 스크롤 뷰
private struct KeywordScrollView: View {
    
    @ObservedObject var viewModel: TodayAnswersViewModel
    
    fileprivate init(viewModel: TodayAnswersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.keywords, id: \.self) { keyword in
                    KeywordSelector(
                        keywordText: keyword,
                        keywordCount: 13) {
                            // TODO: 키워드 선택
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 플로팅 질문 카드
private struct FloatingQuestionCard: View {
  
     var questionContent: String // 질문 내용을 저장할 프로퍼티
     @Binding var tab: Tab // 현재 탭을 저장할 프로퍼티
     @ObservedObject var viewModel: TodayAnswersViewModel // 뷰 모델
     @State private var isCardExpanded = true // 카드 확장 상태
    var questionId: Int?  // 추가됨
    
    
    var todayQuestionText: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        let creatingText = AttributedString("\(questionContent)")
        print(questionContent, "TodayAnswersViewModel에서 todayQuestion 스트링")
        return questionMark + creatingText
    }
 
    var body: some View {
        HStack {
            Text(todayQuestionText)
                .font(.pretendard(.semiBold, size: 15))
                .foregroundStyle(TextLabel.main)
                .lineLimit(isCardExpanded ? 3 : 0)
            Spacer()
            Image(isCardExpanded ? .arrowUp : .arrowDown)
                       .resizable()
                       .frame(width: 28, height: 28)
                       .foregroundColor(.white)
               }
               .onTapGesture {
                   withAnimation {
                       isCardExpanded.toggle() // 확장/축소 상태 토글
                   }
               }
        /*
            Button {
                withAnimation {
                    isCardExpanded.toggle()
                }
            } label: {
                Image(isCardExpanded ? .arrowUp : .arrowDown)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
         */
        
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(GrayScale.secondaryButton)
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
    
}

// MARK: - 답변 스크롤 뷰
private struct AnswerScrollView: View {
 //   @ObservedObject var sharedData = SharedData()
    
    @Binding var tab: Tab
   
  //  let seeMoreAction: () -> Void
    
    @EnvironmentObject var pathModel: PathModel
    @ObservedObject var viewModel: TodayAnswersViewModel
    @Binding private var isBottomSheetPresented: Bool
    

    fileprivate init(viewModel: TodayAnswersViewModel, tab: Binding<Tab>, isBottomSheetPresented: Binding<Bool>) {
        self.viewModel = viewModel
        //sharedData = SharedData()
  //      self.seeMoreAction = {}
        self._isBottomSheetPresented = isBottomSheetPresented
        self._tab = tab
       
    }
  
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
                ForEach(Array(viewModel.answers.enumerated()), id: \.offset) { index, answer in
                    LazyVStack(spacing: 24){
                        SingleAnswerView(answer: answer){
                            isBottomSheetPresented.toggle()
                        }
                /*
                seeMoreAction: {
                            isBottomSheetPresented.toggle()
                        }, seeMoreReport: {
                            tab = .answering
                            return CGPoint(x: 10.0, y: CGFloat(index * 100)) // 단순 예시
                        })
                 */
                    /*
                        .onTapGesture {self.sharedData.reportButtonPosition = CGPoint(x: 270, y: -index * 100)            }
                     */
                        .padding(.horizontal, 24)
                        .sheet(isPresented: $isBottomSheetPresented) {
                            SeeMoreView(isBottomSheetPresented: $isBottomSheetPresented)
                                .presentationDetents([.height(84)])
                        }
                        Separator()
                   
                    }
                    //.padding(.bottom, 16)
                    Spacer()
                        .frame(height: 32)
        }
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 20)
                }
            }
    }
}

struct TodayAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        TodayAnswerView(questionId: 1, tab: .constant(.answering), questionContent: "디폴트")
    }
}



