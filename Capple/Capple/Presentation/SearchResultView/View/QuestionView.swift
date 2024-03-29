import SwiftUI
import FlexView
import Foundation

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionView: View {
    
    @EnvironmentObject var pathModel: PathModel
    
    @State private var showingReportSheet = false // 모달 표시를 위한 상태 변수
    let question: QuestionResponse.Questions.QuestionsInfos // 이 뷰에서 사용할 질문 객체입니다.
    @State private var dateString: String = "" // 상태 변수 정의
    
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
        switch question.questionStatus {
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
        let text = AttributedString("\(question.content)")
        return questionMark + text
    }
    
    /// 키워드 문자열 배열을 반환합니다.
    var tags: [String] {
        
        guard var tagArray = question.tag?
            .split(separator: " ")
            .map(String.init) else {
            return []
        }
        
        // 태그가 3개가 될때까지 모두 삭제
        while tagArray.count > 3 {
            tagArray.removeLast()
        }
        
        return tagArray
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Q.")
                    .font(.pretendard(.bold, size: 16))
                    .foregroundStyle(BrandPink.text)
                
                Spacer()
                    .frame(width: 2)
                
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
                
                Text(formattedDate(from: question.livedAt ?? "default"))
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                    .opacity(question.questionStatus == .live ? 1 : 0.6)
                
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
                    .opacity(question.questionStatus == .live ? 1 : 0.6)
                
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
            Text(question.isAnswered ? question.content : "답변 후 다른 러너의\n생각을 확인해보세요!")
                .foregroundStyle(TextLabel.main)
                .font(.pretendard(.bold, size: 17))
                .lineSpacing(4.0)
            
            Spacer()
                .frame(height: 16)
            
            // MARK: - 태그
            HStack(alignment: .top, spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundColor(BrandPink.text)
                        .frame(height: 10)
                }
                
                Spacer()
                
                if !question.isAnswered { // isAnswered가 true일 때만 표시
                    Button {
                        pathModel.paths.append(
                            .answer(
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
        .background(Background.first) // 배경색을 설정하고 투명도를 조절합니다.
    }
}

struct DummyData {
    static let questionsInfo = QuestionResponse.Questions.QuestionsInfos(questionStatus: .live, livedAt: "2021-01-01T00:00:00Z", content: "This is a sample question", tag: "첫번째 두번째 세번째", isAnswered: true)
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

#Preview {
    QuestionView(question: DummyData.questionsInfo,
                 questionNumber: 0) {}
        .environmentObject(PathModel())
}
