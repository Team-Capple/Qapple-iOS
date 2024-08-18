import SwiftUI
import FlexView
import Foundation

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionCell: View {
    
    @EnvironmentObject var pathModel: Router
    
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    let question: QuestionResponse.Questions.QuestionsInfos // 이 뷰에서 사용할 질문 객체입니다.
    @State private var dateString: String = "" // 상태 변수 정의
    
    let questionNumber: Int
    let seeMoreAction: () -> Void
    
    var questionStatus: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HeaderView(
                question: question,
                seeMoreAction: seeMoreAction
            )
            
            Spacer()
                .frame(height: 16)
            
            ContentView(question: question)
            
            Spacer()
                .frame(height: 16)
            
            AnswerButtonView(question: question)
        }
        .padding(question.questionStatus == .live ? 20 : 0)
        .background(
            Group {
                if question.questionStatus == .live {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.04))
                } else {
                    Background.first
                }
            }
        ) // 배경색을 설정하고 투명도를 조절합니다.
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let question: QuestionResponse.Questions.QuestionsInfos
    let seeMoreAction: () -> Void
    
    var questionStatusRawValue: String {
        switch question.questionStatus {
        case .live:
            return QuestionStatus.live.rawValue
        default:
            return ""
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            Spacer()
                .frame(width: 2)
            
            if question.questionStatus != .live {
                Text("\(getTimePeriod(from: question.livedAt ?? "default") ?? "오전")질문")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
                
                Rectangle()
                    .frame(width: 1, height: 10)
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
            }
            
            Text(formattedDate(from: question.livedAt ?? "default"))
                .font(.pretendard(.semiBold, size: 14))
                .foregroundStyle(GrayScale.icon)
                .opacity(question.questionStatus == .live ? 1 : 0.6)
            
            Spacer()
                .frame(width: 8)
            
            
            // LIVE *questionStatusRawValue가 있어야 하는지 의문!*
            if !questionStatusRawValue.isEmpty{
                Text(questionStatusRawValue)
                    .font(.pretendard(.bold, size: 9))
                    .foregroundColor(.main)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.white.opacity(0.08))
                            .stroke(.onAir, lineWidth: 0.33)
                    )
                
            }
            Spacer()
            
            Button {
                seeMoreAction() // TODO: SearchResultView에서 삭제 및 신고 설정
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(TextLabel.sub2)
                    .frame(width: 20, height: 20)
            }
            
            HStack(alignment: .center) {
                // 이거 뭔가요.......?
            }
        }
    }
    
    /// 2024.08.14 형태의 시간을 반환합니다.
    private func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            return outputFormatter.string(from: date)
        } else {
            return "실패!" // 잘못된 입력 형식일 경우 처리
        }
    }
    
    /// 오전/오후 시간을 표현합니다.
    private func getTimePeriod(from dateString: String) -> String? {
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
}

// MARK: - ContentView

private struct ContentView: View {
    
    let question: QuestionResponse.Questions.QuestionsInfos
    
    /// 리스트 타이틀 텍스트를 반환합니다.
    var listTitleText: AttributedString {
        var questionMark = AttributedString("Q. ")
        questionMark.foregroundColor = BrandPink.text
        let text = AttributedString("\(question.content)")
        return questionMark + text
    }
    
    var body: some View{
        HStack(alignment: .top) {
            
            Text(question.questionStatus == .live ? AttributedString(question.content) : listTitleText)
                .foregroundStyle(TextLabel.main)
                .font(.pretendard(.bold, size: 17))
                .lineSpacing(4.0)
                .frame(maxWidth: 291, alignment: .leading)
        }
    }
}

// MARK: - AnswerButtonView

private struct AnswerButtonView: View {
    
    @EnvironmentObject var pathModel: Router
    
    let question: QuestionResponse.Questions.QuestionsInfos
    
    var body: some View{
        HStack(alignment: .top, spacing: 8) {
            Spacer()
            
            if !question.isAnswered { // isAnswered가 false일 때만 표시
                Button {
                    pathModel.pushView(
                        screen: QuestionListPathType.answer(
                            questionId: question.questionId ?? 0,
                            questionContent: question.content
                        )
                    )
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
}

struct DummyData {
    static let questionsInfo = QuestionResponse.Questions.QuestionsInfos(questionStatus: .live, livedAt: "2021-01-01T00:00:00", content: "아카데미 러너 중 가장 마음에 드는 유형이 있나요?", isAnswered: true)
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

#Preview {
    QuestionCell(question: DummyData.questionsInfo,
                 questionNumber: 0) {}
        .environmentObject(Router(pathType: .questionList))
}
