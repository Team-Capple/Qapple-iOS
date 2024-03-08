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
                    
                    // TODO: 테스트용 코드
                    Task {
                        let tagSearch = try await NetworkManager.fetchSearchTag(request: .init(keyword: "키워드"))
                        let popularTag = try await NetworkManager.fetchPopularTagsInQuestion(request: .init(questionId: 1))
                        print(tagSearch)
                        print(popularTag)
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
