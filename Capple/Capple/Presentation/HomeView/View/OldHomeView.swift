//
//  HomeView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

struct OldHomeView: View {
    
    @StateObject private var pathModel = PathModel()
    @StateObject var answerViewModel: AnswerViewModel = .init()
    @State private var tab: Tab = .answering
    
    var body: some View {
        
        NavigationStack(path: $pathModel.paths) {
            switch tab {
                
            // 답변하기
            case .answering:
                TodayQuestionView(tab: $tab)
                    .navigationDestination(for: PathType.self) { pathType in
                        if pathType == .answer {
                            AnswerView(viewModel: answerViewModel)
                        } else if pathType == .confirmAnswer {
                            ConfirmAnswerView(viewModel: answerViewModel)
                        } else if pathType == .searchKeyword {
                            SearchKeywordView(viewModel: answerViewModel)
                        }
                    }
                
            // 모아보기
            case .collecting:
                SearchResultView(topTab: $tab)
            }
        }
        .environmentObject(pathModel)
    }
}

#Preview {
    OldHomeView()
}
