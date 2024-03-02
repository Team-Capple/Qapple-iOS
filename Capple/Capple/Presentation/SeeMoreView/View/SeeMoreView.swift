//
//  SeeMoreView.swift
//  Capple
//
//  Created by 김민준 on 2/28/24.
//

import SwiftUI

struct SeeMoreView: View {
    
    @Binding var isBottomSheetPresented: Bool
    @Binding var isReportViewPresented: Bool
    
    var body: some View {
        ZStack {
            
            Color(GrayScale.secondaryButton)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 24)
                
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 36, height: 6)
                        .foregroundStyle(Background.first)
                    Spacer()
                }
                
                Button {
                    isBottomSheetPresented = false
                    isReportViewPresented = true
                } label: {
                    Text("신고")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(TextLabel.main)
                }
                .frame(height: 40)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SeeMoreView(isBottomSheetPresented: .constant(false), isReportViewPresented: .constant(false))
}
