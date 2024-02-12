//
//  HomeView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("캐플캐플")
                .foregroundStyle(BrandPink.button)
                .font(.pretendard(.bold, size: 24))
            
            Text("폰트 테스트")
                .font(.pretendard(.semiBold, size: 36))
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
