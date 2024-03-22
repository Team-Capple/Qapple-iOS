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
    //@ObservedObject var viewModel:TodayQuestionViewModel
    let seeMoreAction: () -> Void
    var questionStatus: String = ""
    
    // MARK: - 타임존, 데이트
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
        default:
            return ""
        }
    }
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
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
                
                if !questionStatusRawValue.isEmpty{
                    Text(questionStatusRawValue)
                        .font(.pretendard(.bold, size: 9))
                        .foregroundStyle(.wh)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Context.onAir)
                        .cornerRadius(18, corners: .allCorners)
                    
                }
                Spacer()
                
                HStack(alignment: .center) {
                    
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
                
                
                if questions.isAnswered ?? false { // isAnswered가 true일 때만 표시
                       Button {
                           // TODO: 현희 누나봐주세요!!! (답변하기 뷰 이동)
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
            }
            
            // MARK: - 좋아요, 댓글
            HStack {
                
            }
        }
        .background(Background.first) // 배경색을 설정하고 투명도를 조절합니다.
    }
}
 

struct DummyData {
    static let questionsInfo = QuestionResponse.Questions.QuestionsInfos(questionStatus: .live, livedAt: "2021-01-01T00:00:00Z", content: "This is a sample question", isAnswered: true)
}

// SwiftUI 프리뷰 구성
struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        // 여기서 필요한 모든 데이터를 전달합니다.
        // 예시용으로 임시 데이터를 생성하거나 기본값을 설정합니다.
        QuestionView(tab: .constant(.collecting), questions: DummyData.questionsInfo, seeMoreAction: {}).environmentObject(PathModel())
    }
}



extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
