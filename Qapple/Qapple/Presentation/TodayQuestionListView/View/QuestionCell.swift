import SwiftUI
import Foundation

struct QuestionCell: View {
    
    @EnvironmentObject var pathModel: Router
    
    let question: QuestionResponse.Questions.Content
    let questionNumber: Int
    let seeMoreAction: () -> Void
    
    private var cellColor: Color {
        question.isAnswered
        ? TextLabel.sub4.opacity(0.05) :
        Color.white.opacity(0.04)
    }
    
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
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cellColor)
        )
    }
}

// MARK: - HeaderView

private struct HeaderView: View {
    
    let question: QuestionResponse.Questions.Content
    let seeMoreAction: () -> Void
    
    private var questionStatusRawValue: String {
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
            
            HStack(alignment: .center, spacing: 6) {
                Text("#\(question.questionId)")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 2, height: 10)
                    .foregroundStyle(GrayScale.icon.opacity(0.5))
                
                Text(formattedDate(from: question.livedAt ?? "default"))
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(GrayScale.icon)
            }
            
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
            Button {
                pathModel.pushView(
                    screen: QuestionListPathType.answer(
                        questionId: question.questionId,
                        questionContent: question.content
                    )
                )
            } label: {
                Text(question.isAnswered ? "답변완료" : "답변하기")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(question.isAnswered ? TextLabel.disable : TextLabel.main)
                    .frame(width: 70, height: 36)
                    .background(question.isAnswered ? GrayScale.secondaryButton : BrandPink.button)
                    .cornerRadius(30, corners: .allCorners)
            }
            .disabled(question.isAnswered)
        }
    }
}

#Preview {
    ZStack {
        Color.Background.first.ignoresSafeArea()
        
        VStack {
            QuestionCell(
                question: .init(
                    questionId: 13,
                    questionStatus: "LIVE",
                    livedAt: "2021-01-01T00:00:00",
                    content: "아카데미 러너 중 가장 마음에 드는 유형이 있나요?",
                    isAnswered: true
                ),
                questionNumber: 0
            ) {}
            
            QuestionCell(
                question: .init(
                    questionId: 13,
                    questionStatus: "LIVE",
                    livedAt: "2021-01-01T00:00:00",
                    content: "아카데미 러너 중 가장 마음에 드는 유형이 있나요?",
                    isAnswered: false
                ),
                questionNumber: 0
            ) {}
        }
    }
    .environmentObject(Router(pathType: .questionList))
}
