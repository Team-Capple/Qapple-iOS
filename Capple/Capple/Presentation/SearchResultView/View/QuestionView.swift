//
//  QuestionView.swift
//  Capple
//
//  Created by 심현희 Lee on 2/23/24.
//

import SwiftUI

struct QuestionView: View {
    var question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.title)
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.bold)
            
            Text("\(question.likes) likes • \(question.comments) comments")
                .foregroundColor(.gray)
                .font(.caption)
            
            Divider().background(Color.gray)
            
            Text(question.detail)
                .foregroundColor(.white)
                .font(.body)
            
            HStack {
                ForEach(question.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("\(question.likes)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "message")
                    .foregroundColor(.white)
                Text("\(question.comments)")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
