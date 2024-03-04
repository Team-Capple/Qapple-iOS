//
//  SignUpCompletedView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/22/24.
//

import SwiftUI

struct SignUpCompletedView: View {
    // 추후 중복 검사 변수 나오면 삭제 예정
    @State private var isChecked: Bool = false
    @State private var isCompleted: Bool = true
    
    var body: some View {
        
        VStack(spacing: 0) {
            CustomNavigationBar(
                leadingView: { },
                principalView: { },
                trailingView: { },
                backgroundColor: Background.first)

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("캐플에 오신걸 환영합니다")
                    Text("당신의 이야기를 들려주세요")
                }
                .foregroundStyle(TextLabel.main)
                .font(Font.pretendard(.bold, size: 24))
                .kerning(0.72)
                .frame(height: 54)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 60, leading: 30, bottom: 0, trailing: 0))
            
            Spacer()
            
            Button {
                // 중복 체크가 성공했으면
                isChecked.toggle()
            } label: {
                Image("NextDefaultButton")
            }
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: isCompleted)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isChecked) {
            HomeView()
        }
    }
}

#Preview {
    SignUpCompletedView()
}
