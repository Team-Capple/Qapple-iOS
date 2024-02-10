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
            Text("Hello, world!")
                .foregroundStyle(BrandPink.button)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
