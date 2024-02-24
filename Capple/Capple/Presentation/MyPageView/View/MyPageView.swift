//
//  MyPageView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                Background.first
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    MyProfileSummary()

                    VStack {
                        Text("질문/답변")
                            .foregroundStyle(TextLabel.main)
                            .font(Font.pretendard(.bold, size: 20))
                            .frame(height: 14)
                    }
                    .padding(24)
                    
                }
            }
        }
        .background(Background.first)
        
    }
}

#Preview {
    MyPageView()
}
