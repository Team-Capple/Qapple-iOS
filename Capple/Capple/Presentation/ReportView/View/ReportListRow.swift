//
//  ReportListRow.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct ReportListRow: View {
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Button {
            
        } label: {
            Text(title)
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.wh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 48)
                .background(Background.first)
        }
    }
}

#Preview {
    ZStack {
        
        Color(Background.first)
            .ignoresSafeArea()
     
        ReportListRow(title: "버튼입니당")
    }
}
