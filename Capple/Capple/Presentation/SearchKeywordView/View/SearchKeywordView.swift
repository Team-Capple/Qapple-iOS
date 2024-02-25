//
//  SearchKeywordView.swift
//  Capple
//
//  Created by 김민준 on 2/26/24.
//

import SwiftUI

struct SearchKeywordView: View {
    
    @StateObject var viewModel: SearchKeywordViewModel
    
    var body: some View {
        ZStack {
            Color(Background.second)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SearchKeywordView(viewModel: .init())
}
