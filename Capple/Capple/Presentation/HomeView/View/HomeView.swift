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
                        let tagSearch = try await NetworkManager.fetchSearchTag(request: .init(keyword: "키워드"))
                        print(tagSearch)
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
