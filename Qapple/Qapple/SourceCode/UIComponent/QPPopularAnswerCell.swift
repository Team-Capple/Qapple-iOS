//
//  QPPopularAnswerCell.swift
//  Qapple
//
//  Created by 문인범 on 5/19/25.
//

import SwiftUI


enum PopularAnswerCellStatus: Equatable {
    case none
    case todayQuestion
    case popularAnswer(Answer, Question)
}

struct QPPopularAnswerCell: View {
    let status: PopularAnswerCellStatus
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Image(status == .todayQuestion ? .questionReady : .questionComplete)
                .resizable()
                .frame(width: 22, height: 21)
                .padding(.vertical, 13)
                .padding(.leading, 18)
            
            switch status {
            case .todayQuestion:
                Text("오늘의 질문이 도착했어요!")
                    .font(.pretendard(.semiBold, size: 15))
                    .foregroundStyle(.main)
                    .padding(.top, 15)
                    .padding(.leading, 6)
            case let .popularAnswer(answer, _):
                VStack(alignment: .leading, spacing: 5) {
                    Text("오늘의 인기 답변")
                        .font(.pretendard(.light, size: 12))
                        .foregroundStyle(.main.opacity(0.5))
                    
                    Text(answer.content)
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(.main)
                        .lineLimit(1)
                }
                .padding(.vertical, 13)
                .padding(.leading, 7.5)
                
            case .none:
                EmptyView()
            }
               
            Spacer()
        }
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.questionNoti)
                
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(
//                        LinearGradient(
//                            colors: [.popularStart, .popularEnd],
//                            startPoint: .leading,
//                            endPoint: .trailing
//                        )
//                        .opacity(0.17)
                        RadialGradient(colors: [.popularStart, .popularEnd], center: .center, startRadius: 0, endRadius: 100)
                            .opacity(0.17)
                        
                    )
            }
        }
    }
}


#Preview {
    VStack {
        QPPopularAnswerCell(status: .todayQuestion)
    }
    .padding(.horizontal, 10)
}
