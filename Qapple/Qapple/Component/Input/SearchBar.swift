//
//  SearchBar.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - SearchBar

struct SearchBar: View {
    
    @Binding private(set) var searchText: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(GrayScale.icon)
            
            TextField("내용으로 검색이 가능해요", text: $searchText)
                .pretendard(.bold, 14)
        }
        .padding(8)
        .background(GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
