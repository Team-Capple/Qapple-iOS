//
//  SeeMoreView.swift
//  Capple
//
//  Created by 김민준 on 2/28/24.
//

import SwiftUI

struct SeeMoreView: View {
    
    enum AnswerType {
        case mine // 내가 작성한 답변
        case others // 다른 사람이 작성한 답변
    }
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var pathModel: PathModel
    
    @State private var isAnswerDeleteAlertPresented = false
    @State private var isAnswerDeleteCompleteAlertPresented = false
    
    let answerType: AnswerType
    let answerId: Int
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer().frame(height: 12)
                
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 56, height: 4)
                        .foregroundStyle(GrayScale.secondaryButton)
                    Spacer()
                }
                
                switch answerType {
                case .mine:
                    SeeMoreCell(title: "삭제하기") {
                        isAnswerDeleteAlertPresented.toggle()
                    }
                    
                case .others:
                    SeeMoreCell(title: "신고하기") {
                        presentationMode.wrappedValue.dismiss()
                        pathModel.paths.append(.report)
                    }
                }

                Spacer()
            }
            .alert("답변을 삭제하시겠어요?", isPresented: $isAnswerDeleteAlertPresented) {
                Button("취소", role: .cancel) {}
                Button("삭제하기", role: .destructive) {
                    
                    isAnswerDeleteCompleteAlertPresented.toggle()
                }
            } message: {
                Text("삭제한 답변은 복구할 수 없어요")
            }
            .alert("답변이 삭제되었어요", isPresented: $isAnswerDeleteCompleteAlertPresented) {
                Button("확인", role: .none) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            print("답변 ID: \(answerId)")
        }
    }
}

// MARK: - SeeMoreCell
private struct SeeMoreCell: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(Context.warning)
        }
        .frame(height: 40)
        .padding(.horizontal, 24)
    }
}

#Preview {
    SeeMoreView(answerType: .mine, answerId: 1)
}
