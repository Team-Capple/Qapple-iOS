//
//  SignInView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/11/24.
//

import SwiftUI

struct SignInView: View {
    @State private var clickedLoginButton: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.first
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // 로고
                    Text("CAPPLE")
                        .foregroundStyle(Color.main)
                        .font(.system(size: 56))
                        .fontWeight(.bold)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    // 로그인 버튼
                    Button {
                        // TODO: 로그인 기능 구현
                        /// 이미 회원이면 메인화면으로 이동
                        /// 회원이 아니라면 회원가입으로 이동
                        
                        clickedLoginButton.toggle()
                        
                    } label: {
                        Image("AppleIDLoginButton")
                    }
                }
            }
            .navigationDestination(isPresented: $clickedLoginButton) {
                SignUpNicknameView()
            }
        }
    }
}

#Preview {
    SignInView()
}
