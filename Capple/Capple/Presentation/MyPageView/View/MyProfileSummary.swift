//
//  MyProfileSummary.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct MyProfileSummary: View {
    var nickname: String = "튼튼한 당근"
    var joinDate: String = "2024.02.09"
    
    var body: some View {
        ZStack(alignment: .leading) {
            Background.second
                .ignoresSafeArea()
            
            HStack(spacing: 16) {
                // 임시
                Image("Capple")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .background(Color.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(nickname)")
                        .foregroundStyle(TextLabel.main)
                        .font(Font.pretendard(.bold, size: 20))
                        .frame(height: 14)
                    
                    Text("\(joinDate) 가입")
                        .foregroundStyle(TextLabel.sub3)
                        .font(Font.pretendard(.semiBold, size: 14))
                        .frame(height: 10)
                }
                .frame(height: 40)
            }
            .padding(24)
        }
        .frame(height: 120)
    }
}

#Preview {
    MyProfileSummary()
}
