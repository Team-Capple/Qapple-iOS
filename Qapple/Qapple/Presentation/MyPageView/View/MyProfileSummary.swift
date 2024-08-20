//
//  MyProfileSummary.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct MyProfileSummary: View {
    
    var nickname: String
    var joinDate: String
    var profileImage: String?
    
    var body: some View {
        HStack(spacing: 16) {
            Image(.cappleDefaultProfile)
                .resizable()
                .frame(width: 72, height: 72)
                .background(Color.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(nickname)")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 20))
                    .frame(height: 14)
                
                Text("\(joinDate)")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.semiBold, size: 14))
                    .frame(height: 10)
            }
            .frame(height: 40)
            Spacer()
        }
        .padding(24)
        .background(Background.second)
    }
}

#Preview {
    MyProfileSummary(
        nickname: "튼튼한 당근",
        joinDate: "2024.02.09"
    )
}
