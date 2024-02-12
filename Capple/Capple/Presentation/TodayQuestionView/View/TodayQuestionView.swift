//
//  TodayQuestionView.swift
//  Capple
//
//  Created by 김민준 on 2/12/24.
//

import SwiftUI

struct TodayQuestionView: View {
    
    @StateObject var viewModel: TodayQuestionViewModel
    
    var body: some View {
        Text("캐플캐플")
    }
}

#Preview {
    TodayQuestionView(viewModel: TodayQuestionViewModel())
}
