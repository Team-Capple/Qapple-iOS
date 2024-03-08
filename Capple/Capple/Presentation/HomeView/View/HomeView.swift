//
//  HomeView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var topTab: TopTab = .answering
    
    var body: some View {
        switch topTab {
        case .answering:
            TodayQuestionView(topTab: $topTab)
                .onAppear {
                    Task {
                        try await NetworkManager.fetchMainQuestions()
                        try await NetworkManager.fetchAnswersOfQuestion(request: .init(questionId: 1, keyword: "string", size: 3))
                        try await NetworkManager.fetchSearchTag(request: .init(keyword: "string"))
                        try await NetworkManager.fetchPopularTagsInQuestion(request: .init(questionId: 1))
                    }
                }
        case .collecting:
            SearchResultView(topTab: $topTab)
        }
    }
}

#Preview {
    HomeView()
}
