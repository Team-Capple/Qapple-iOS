import SwiftUI

// 하나의 질문을 보여주는 뷰를 정의합니다.
struct QuestionView: View {
    var question: Question // 이 뷰에서 사용할 질문 객체입니다.

    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // 세로 스택을 사용해 요소들을 정렬합니다.
            Text(question.title) // 질문의 제목을 표시합니다.
                .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
                .font(.title3) // 글자 크기를 설정합니다.
                .fontWeight(.bold) // 글자 두께를 굵게 설정합니다.
            
            Text("\(question.likes) likes • \(question.comments) comments") // 좋아요 수와 댓글 수를 표시합니다.
                .foregroundColor(.gray) // 글자 색상을 회색으로 설정합니다.
                .font(.caption) // 작은 글자 크기로 설정합니다.
            
            Divider().background(Color.gray) // 구분선을 추가합니다.
            
            Text(question.detail) // 질문의 상세 설명을 표시합니다.
                .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
                .font(.body) // 본문 글자 크기로 설정합니다.
            
            HStack { // 가로 스택을 사용해 태그를 나열합니다.
                ForEach(question.tags, id: \.self) { tag in
                    Text("#\(tag)") // 각 태그를 표시합니다.
                        .foregroundColor(.blue) // 글자 색상을 파란색으로 설정합니다.
                        .font(.caption) // 작은 글자 크기로 설정합니다.
                }
            }
            
            HStack { // 좋아요와 댓글 아이콘을 가로로 나열합니다.
                Image(systemName: "heart.fill") // 좋아요 아이콘을 표시합니다.
                    .foregroundColor(.red) // 아이콘 색상을 빨간색으로 설정합니다.
                Text("\(question.likes)") // 좋아요 수를 표시합니다.
                    .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
                    .font(.subheadline) // 약간 작은 글자 크기로 설정합니다.
                Spacer() // 좋아요와 댓글 사이에 공간을 추가합니다.
                Image(systemName: "message") // 댓글 아이콘을 표시합니다.
                    .foregroundColor(.white) // 아이콘 색상을 흰색으로 설정합니다.
                Text("\(question.comments)") // 댓글 수를 표시합니다.
                    .foregroundColor(.white) // 글자 색상을 흰색으로 설정합니다.
                    .font(.subheadline) // 약간 작은 글자 크기로 설정합니다.
            }
        }
        .padding() // 내부 요소와의 간격을 설정합니다.
        .background(Color.gray.opacity(0.2)) // 배경색을 설정하고 투명도를 조절합니다.
        .cornerRadius(10) // 모서리를 둥글게 처리합니다.
        .padding(.horizontal) // 좌우 간격을 설정합니다.
    }
}

