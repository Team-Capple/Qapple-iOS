import SwiftUI
import FlexView
import Foundation

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionView: View {
    @EnvironmentObject var pathModel: PathModel
    @Binding var tab: Tab
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    @State var questions: QuestionResponse.Questions.QuestionsInfos // 이 뷰에서 사용할 질문 객체입니다.
    @State private var dateString: String = "" // 상태 변수 정의
  //  @ObservedObject var viewModel:TodayQuestionViewModel
    let seeMoreAction: () -> Void
    var questionStatus: String = ""
    
    // MARK: - 타임존, 데이트
    // DateFormatter 인스턴스 생성 및 설정
    // 문자열 날짜 형식을 위한 DateFormatter 인스턴스 생성
    func getAmPmFromDateString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // 입력 문자열 형식
        formatter.timeZone = TimeZone(abbreviation: "UTC") // API 시간대 (UTC)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a" // '오전' 또는 '오후' 표시
        outputFormatter.timeZone = TimeZone(abbreviation: "KST") // 한국 시간대
        outputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        
        if let date = formatter.date(from: dateString) {
            return outputFormatter.string(from: date) // '오전' 또는 '오후'
        } else {
            return "시간 변환 실패"
        }
    }
    
    func stringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 날짜 형식은 입력되는 문자열 형식에 맞춰야 합니다.
       // formatter.locale = Locale(identifier: "en_US_POSIX") // ISO8601 등의 표준 형식을 처리하기 위해 권장
        return formatter.date(from: dateString)
    }
    
    func formattedDate(from dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC로 설정

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.timeZone = TimeZone.current // 현재 시스템 시간대 사용

      
        if let date = isoFormatter.date(from: dateString) {
            return outputFormatter.string(from: date) // Return the formatted date string
        } else {
           
            let standardFormatter = DateFormatter()
            standardFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Handle strings without fractional seconds
            standardFormatter.timeZone = TimeZone(abbreviation: "UTC") // Match the time zone used in your original strings if necessary

            if let date = standardFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            } else {
                return "날짜 변환 실패"
            }
        }
    }


    var questionStatusRawValue: String {
        switch questions.questionStatus {
        case .live:
            return QuestionStatus.live.rawValue
        case .old:
            return QuestionStatus.old.rawValue
        case .hold:
            return QuestionStatus.hold.rawValue
        case .pending:
            return QuestionStatus.pending.rawValue
        default:
            return "UNKNOWN"
        }
    }


    //@State private var isLike = false
    //@State private var isComment = false
    
    var body: some View {
        
    //    NavigationLink(destination: TodayAnswerView(questionId: questions.questionId, tab: $tab, questionContent: questions.content)) {
            // QuestionView의 메인 콘텐츠를 여기에 배치합니다.
        
            VStack(alignment: .leading) { // 세로 스택을 사용해 요소들을 정렬합니다.
                HStack(alignment: .center) {
                    Text("\(questions.livedAt ?? "오전 질문" == QuestionTimeZone.am.rawValue || questions.livedAt ?? "오전 질문" == QuestionTimeZone.amCreate.rawValue ? "오전" : "오후")질문")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(GrayScale.icon)
                    
                    Spacer()
                        .frame(width: 4)
                    
                    Rectangle()
                        .frame(width: 1, height: 10)
                        .foregroundStyle(GrayScale.icon)
                    
                    Spacer()
                        .frame(width: 4)
                   
                    Text(formattedDate(from: questions.livedAt ?? "default"))
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(GrayScale.icon)
                    
                    
                    Spacer()
                        .frame(width: 8)
             
                        Text(questionStatusRawValue)
                            .font(.pretendard(.bold, size: 9))
                            .foregroundStyle(.wh)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Context.onAir)
                            .cornerRadius(18, corners: .allCorners)
                    
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        
                        Button {
                            seeMoreAction()
                            
                          //  showingReportSheet = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(TextLabel.sub2)
                                .frame(width: 20, height:  20)
                        }
                       
                       
                        
                    }
                    
                }
                        
                        
                    Spacer()
                        .frame(height: 16)
                    
                    // MARK: - 본문
                    Text(questions.content ?? "Default Content") // 질문의 내용을 표시합니다.
                        .font(.pretendard(.bold, size: 17))
                        .foregroundStyle(TextLabel.main)
                    
                    Spacer()
                        .frame(height: 20)
                    
                HStack {
                  
                    Text(questions.tag?
                           .split(separator: " ")
                           .map { "#\($0)" }
                           .joined(separator: " ") ?? "#tag")
                           .font(.pretendard(.semiBold, size: 14))
                           .foregroundStyle(BrandPink.text)
                   
                

                    Spacer()
                        
                    Button {
                        pathModel.paths.append(.answer)
                    } label: {
                        Text("답변하기")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(TextLabel.main)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(BrandPink.button)
                            .cornerRadius(30, corners: .allCorners)
                    }
                }
                    
                    // MARK: - 좋아요, 댓글
                    HStack {
    //                    Button {
    //                        isLike.toggle()
    //                        viewModel.likeButtonTapped(for: questions)
    //                        // TODO: - 좋아요 탭 기능 구현
    //                    } label: {
    //                        HStack(spacing: 6) {
    //                            Image(isLike ? .heartActive : .heart)
    //                                .resizable()
    //                                .frame(width: 24, height: 24)
    //                                .foregroundStyle(isLike ? BrandPink.button : GrayScale.secondaryButton)
    //                            Text(String(questions.likeCount ?? 0)) // 질문의 내용을 표시합니다.
    //                                .font(.pretendard(.medium, size: 15))
    //                                .foregroundStyle(TextLabel.sub3)
    //
    //                        }
    //                    }
    //
    //                    Spacer()
    //                        .frame(width: 12)
    //
    //                    Button {
    //                        isComment.toggle()
    //                        // TODO: - 댓글 창 이동
    //                    } label: {
    //                        HStack(spacing: 6) {
    //                            Image(isComment ? .commentActive : .comment)
    //                                .resizable()
    //                                .frame(width: 24, height: 24)
    //                                .foregroundStyle(isComment ? BrandPink.button : GrayScale.secondaryButton)
    //
    //                            Text(String(questions.commentCount ?? 0))
    //                                .font(.pretendard(.medium, size: 15))
    //                                .foregroundStyle(TextLabel.sub3)
    //                        }
    //                    }
                    }
                }
         
        
            
                .background(Background.first) // 배경색을 설정하고 투명도를 조절합니다.
        }
        
        }
    

/*
#Preview {
    QuestionView(tab: $tab, questions: .init(), seeMoreAction: {})
}
 */

        extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
