import SwiftUI
import FlexView
import Foundation

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionCell: View {
    
    @EnvironmentObject var pathModel: Router
    
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    let question: QuestionResponse.Questions.Content // 이 뷰에서 사용할 질문 객체입니다.
    @State private var dateString: String = "" // 상태 변수 정의
    
    let questionNumber: Int
    let seeMoreAction: () -> Void
    
    var questionStatus: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HeaderView(
                question: question,
                seeMoreAction: seeMoreAction
            )
            
            ContentView(question: question)
                .padding(.top, 8)
                .padding(.trailing, 90 + 16)
            
            AnswerButtonView(question: question)
                .padding(.top, 8)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.04))) // 배경색을 설정하고 투명도를 조절합니다.
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let question: QuestionResponse.Questions.Content
    let seeMoreAction: () -> Void
    
    var questionStatusRawValue: String {
        switch question.questionStatus {
        case "LIVE":
            return QuestionStatus.live.rawValue
        default:
            return ""
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            Spacer()
                .frame(width: 2)
            
            Text(formattedDate(from: question.livedAt ?? "default"))
                .font(.pretendard(.regular, size: 13))
                .foregroundStyle(GrayScale.icon)
            
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
        }
    }
    
    /// 2024.08.14 형태의 시간을 반환합니다.
    private func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM.dd"
            return outputFormatter.string(from: date)
        } else {
            return "실패!" // 잘못된 입력 형식일 경우 처리
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let question: QuestionResponse.Questions.Content
    
    var body: some View{
        Text(question.content)
            .foregroundStyle(TextLabel.main)
            .font(.pretendard(.bold, size: 17))
            .lineSpacing(4.0)
            .lineLimit(2)
    }
}

// MARK: - AnswerButtonView

private struct AnswerButtonView: View {
    
    @EnvironmentObject var pathModel: Router
    
    let question: QuestionResponse.Questions.Content
    
    var body: some View{
        HStack(alignment: .top, spacing: 8) {
            Spacer()
            
            if !question.isAnswered { // isAnswered가 false일 때만 표시
                Button {
                    pathModel.pushView(
                        screen: QuestionListPathType.answer(
                            questionId: question.questionId,
                            questionContent: question.content
                        )
                    )
                } label: {
                    Text("답변하기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(TextLabel.main)
                        .frame(width: 70, height: 36)
                        .background(BrandPink.button)
                        .cornerRadius(30, corners: .allCorners)
                }
            }
        }
    }
}

struct DummyData {
    static let questionsInfo = QuestionResponse.Questions.Content(
        questionId: 0,
        questionStatus: "LIVE",
        livedAt: "2021-01-01T00:00:00",
        content: "아카데미 러너 중 가장 마음에 드는 유형이 있나요?",
        isAnswered: true
    )
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: self)
    }
}

#Preview {
    ZStack {
        Color.Background.first.ignoresSafeArea()
        
        QuestionCell(question: DummyData.questionsInfo,
                     questionNumber: 0) {}
            .environmentObject(Router(pathType: .questionList))
    }
}
