import SwiftUI
import FlexView

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionView: View {
    
    var question: Question // 이 뷰에서 사용할 질문 객체입니다.
    let seeMoreAction: () -> Void
    
    @State private var isLike = false
    @State private var likeCount = 32
    
    @State private var isComment = false
    @State private var commentCount = 48

    var body: some View {
        VStack(alignment: .leading) { // 세로 스택을 사용해 요소들을 정렬합니다.
            
            // MARK: - 상단 날짜
            HStack(alignment: .center) {
                Text("\(question.timeZone == .am || question.timeZone == .amCreate ? "오전" : "오후")질문")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
                
                Rectangle()
                    .frame(width: 1, height: 10)
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 4)
                
                Text("\(question.date.fullDate)")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(GrayScale.icon)
                
                Spacer()
                    .frame(width: 8)
                
                if question.state == .ready || question.state == .complete {
                    Text("ON AIR")
                        .font(.pretendard(.bold, size: 9))
                        .foregroundStyle(.wh)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Context.onAir)
                        .cornerRadius(18, corners: .allCorners)
                }
                
                Spacer()
                
                Button {
                     seeMoreAction()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(TextLabel.sub2)
                        .frame(width: 20, height: 20)
                }
            }
            
            Spacer()
                .frame(height: 16)
            
            // MARK: - 본문
            Text(question.title) // 질문의 제목을 표시합니다.
                .font(.pretendard(.bold, size: 17))
                .foregroundStyle(TextLabel.main)
            
            Spacer()
                .frame(height: 20)
            
            // MARK: - 키워드
            FlexView(data: question.keywords, spacing: 8, alignment: .leading) { keyword in
                Text("#\(keyword.name)")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(BrandPink.text)
            }
            
            Spacer()
                .frame(height: 16)
            
            // MARK: - 좋아요, 댓글
            HStack {
                Button {
                    isLike.toggle()
                    // TODO: - 좋아요 탭 기능 구현
                } label: {
                    HStack(spacing: 6) {
                        Image(isLike ? .heartActive : .heart)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isLike ? BrandPink.button : GrayScale.secondaryButton)
                        
                        Text("\(likeCount)")
                            .font(.pretendard(.medium, size: 15))
                            .foregroundStyle(TextLabel.sub3)
                    }
                }
                
                Spacer()
                    .frame(width: 12)
                
                Button {
                    isComment.toggle()
                    // TODO: - 댓글 창 이동
                } label: {
                    HStack(spacing: 6) {
                        Image(isComment ? .commentActive : .comment)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isComment ? BrandPink.button : GrayScale.secondaryButton)
                        
                        Text("\(commentCount)")
                            .font(.pretendard(.medium, size: 15))
                            .foregroundStyle(TextLabel.sub3)
                    }
                }
                
                Spacer()
                
                Button {
                    // TODO: 답변하기 화면 이동
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
        .background(Background.first) // 배경색을 설정하고 투명도를 조절합니다.
    }
}

#Preview {
    QuestionView(
        question: .init(
            id: 0,
            timeZone: .am,
            date: Date(),
            state: .complete,
            title: "오전 질문에 답변 후\n모든 내용을 확인해보세요",
            keywords: [.init(name: "무자비"), .init(name: "당근맨"), .init(name: "와플대학")],
            likes: 38,
            comments: 185
        ), seeMoreAction: {}
    )
}
