//
//  CommentView.swift
//  Qapple
//
//  Created by 문인범 on 8/8/24.
//

import SwiftUI

struct CommentView: View {
    @State private var text: String = ""
    var body: some View {
        ZStack {
            Color.bk
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        // 데이터 연결
                        ForEach(0..<5, id: \.self) { _ in
                            CommentCell()
                            
                            seperator
                        }
                    }
                    .padding(.top, 10)
                }
                
                addComment
            }
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
                .padding()
            
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 49, height: 40)
                        .foregroundStyle(.button)
                    
                    Image(systemName: "arrowshape.up.fill")
                        .foregroundStyle(.wh)
                }
            }
            .padding(5)
        }
        .background {
            RoundedRectangle(cornerRadius: 11)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.disable)
        }
        
        .frame(minHeight: 50)
        .padding(.horizontal, 16)

    }
}

#Preview {
//    CommentView()
    TestView()
}


struct TestView: View {
    @State private var toggle: Bool = false
    
    var body: some View {
        VStack {
            Button("토글") {
                self.toggle.toggle()
            }
        }
        .sheet(isPresented: $toggle) {
            CommentView()
                .presentationDetents([.height(500), .large])
        }
    }
}
