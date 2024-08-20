//
//  CommentView.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentView: View {
    @State private var text: String = ""
    
    let post: Post
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            Color.bk
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                BulletinBoardCell(post: post, seeMoreAction: {})
                    .frame(width: UIScreen.main.bounds.width)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // 데이터 연결
                        ForEach(0..<10, id: \.self) { _ in
                            CommentCell(isMine: true)
                            
                            seperator
                        }
                        CommentCell(isMine: false)
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .overlay(alignment: .bottom) {
            addComment
                .frame(width: screenWidth)
        }
    }
    
    var seperator: some View {
        Rectangle()
            .foregroundStyle(Color.placeholder)
            .frame(height: 1)
    }
    
    var addComment: some View {
        HStack(alignment: .bottom) {
            TextField("댓글 추가", text: $text, axis: .vertical)
                .font(.pretendard(.regular, size: 17))
                .lineLimit(...3)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button {
                
            } label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.wh)
            }
            .padding(.trailing, 12)
            .padding(.bottom, 12)
        }
        .background {
            RoundedRectangle(cornerRadius: 11)
                .foregroundStyle(Color.placeholder)
        }
        
        .frame(minHeight: 50)
        .padding(.horizontal, 16)

    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CommentView(post: Post(
        anonymityIndex: 0,
        isMine: true,
        content: "다들 매크로 팀원 조합 어떠신가요?",
        isLike: true,
        likeCount: 4,
        commentCount: 1,
        writingDate: .now
    ))
}
