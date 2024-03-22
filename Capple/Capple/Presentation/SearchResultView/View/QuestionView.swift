import SwiftUI
import FlexView
import Foundation

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    @State var questions: QuestionResponse.Questions.QuestionsInfos // 이 뷰에서 사용할 질문 객체입니다.
    @State private var dateString: String = "" // 상태 변수 정의
    
    @Binding var tab: Tab
    
    let questionNumber: Int
    let seeMoreAction: () -> Void
    
    var questionStatus: String = ""
    
    // MARK: - 메서드
    func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        } else {
            return "실패!" // 잘못된 입력 형식일 경우 처리
        }
    }
    // MARK: - 오전/오후 시간표현
    func getTimePeriod(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국 시간으로 설정
        
        if let date = inputFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            // 오전 7시 ~ 오후 6시 : AM
            // 오후 6시 ~ 오전 1시 : PM
            if (7...13).contains(hour) {
                return "오전"
            } else if (14...15).contains(hour) && (0...5).contains(minute) {
                return "오전"
            } else if (18...24).contains(hour) ||  0 == hour {
                return "오후"
            } else if (1...2).contains(hour) && (0...5).contains(minute) {
                return "오후"
            } else {
                return "특별"
            }
        } else {
            return "잘못됨" // 잘못된 입력 형식일 경우 처리
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
    
    /// 리스트 타이틀 텍스트를 반환합니다.
    var listTitleText: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        var text = AttributedString("\(questions.content)")
        return questionMark + text
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("\(getTimePeriod(from: questions.livedAt ?? "default") ?? "오전")질문")
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
                    .opacity(questions.questionStatus == .live ? 1 : 0.6)
                
                Spacer()
                    .frame(width: 4)
                
                Rectangle()
                    .frame(width: 1, height: 10)
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
                
                Text("#\(questionNumber)")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                    .opacity(questions.questionStatus == .live ? 1 : 0.6)
                
                Spacer()
                    .frame(width: 8)
                
                // LIVE
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
            Text(questions.isAnswered ? listTitleText : "질문에 답변 후\n모든 내용을 확인해보세요!") // 질문의 내용을 표시합니다.
                .font(.pretendard(.bold, size: 17))
                .foregroundStyle(TextLabel.main)
                .lineSpacing(4.0)
            
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
                
                if questions.isAnswered == false { // isAnswered가 true일 때만 표시
                    Button {
                        // TODO: 답변하기 뷰에서 id 까지 전달 => 제목 보여주기(정보는 있음)
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
        }
        .background(Background.first) // 배경색을 설정하고 투명도를 조절합니다.
    }
}

struct DummyData {
    static let questionsInfo = QuestionResponse.Questions.QuestionsInfos(questionStatus: .live, livedAt: "2021-01-01T00:00:00Z", content: "This is a sample question", isAnswered: true)
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

#Preview {
    QuestionView(questions: DummyData.questionsInfo, tab: .constant(.collecting),
                 questionNumber: 0) {}
        .environmentObject(PathModel())
}
