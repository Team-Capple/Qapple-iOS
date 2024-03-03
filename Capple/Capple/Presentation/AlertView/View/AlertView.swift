//
//  AlertView.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct AlertView: View {
    
    @StateObject var viewModel: AlertViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(
                    leadingView:{
                        CustomNavigationBackButton(buttonType: .arrow)
                    },
                    principalView: {
                        Text("알림")
                            .font(Font.pretendard(.semiBold, size: 15))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {},
                    backgroundColor: .clear
                )
                
                VStack(spacing: 0) {
                    ForEach(viewModel.alerts, id: \.self) { alert in
                        AlertListRow(alert: alert)
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    AlertView(viewModel: .init())
}
