//
//  TabType.swift
//  Qapple
//
//  Created by 김민준 on 8/15/24.
//

import Foundation

enum TabType: CaseIterable, Identifiable {
    case questionList
    case bulletinBoard
    case myProfile
    
    var id: String {
        return self.title
    }
    
    var title: String {
        switch self {
        case .questionList: return "오늘의 질문"
        case .bulletinBoard: return "게시판"
        case .myProfile: return "프로필"
        }
    }
    
    var icon: String {
        switch self {
        case .questionList:
            return "questionmark.bubble.fill"
            
        case .bulletinBoard:
            return "list.clipboard.fill"
            
        case .myProfile:
            return "person.fill"
        }
    }
}
