//
//  CustonNavigationBar.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/25/24.
//

import SwiftUI

struct CustomNavigationBar<Leading: View, Principal: View, Trailing: View>: View {
    let leadingView: Leading?
    let principalView: Principal?
    let trailingView: Trailing?
    var backgroundColor: Color
    
    init(@ViewBuilder leadingView: () -> Leading, @ViewBuilder principalView: () -> Principal, @ViewBuilder trailingView: () -> Trailing, backgroundColor: Color) {
        self.leadingView = leadingView()
        self.principalView = principalView()
        self.trailingView = trailingView()
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        
        ZStack {
            HStack {
                if let leadingView = leadingView {
                    leadingView
                }
                
                Spacer()
                
                if let trailingView = trailingView {
                    trailingView
                }
            }
            if let principalView = principalView {
                principalView
            }
        }
        .padding()
        .frame(height: 48)
        .background(backgroundColor)
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(
            leadingView: { Text("Leading").foregroundColor(.white) },
            principalView: { Text("Principal").foregroundColor(.white) },
            trailingView: { Text("Trailing").foregroundColor(BrandPink.text) },
            backgroundColor: Background.first
        )
    }
}
