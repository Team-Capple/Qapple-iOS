//
//  SignUpTermsAgreementView.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/12/24.
//

import SwiftUI

struct SignUpTermsAgreementView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isChecked: Bool = false // 추후 중복 검사 변수 나오면 삭제 예정
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomNavigationBar(
                leadingView: { CustomNavigationBackButton(buttonType: .arrow) {
                    pathModel.paths.removeLast()
                }},
                principalView: { Text("약관 동의")
                    .font(Font.pretendard(.semiBold, size: 15))
                    .foregroundStyle(TextLabel.main) },
                trailingView: { },
                backgroundColor: Background.first)
            
            Spacer()
                .frame(height: 32)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("한 단계 남았어요")
                    .foregroundStyle(TextLabel.main)
                    .font(Font.pretendard(.bold, size: 24))
                    .frame(height: 17)
                
                Spacer()
                    .frame(height: 22)
                
                Text("회원가입을 위해서는 약관 동의가 필요해요")
                    .foregroundStyle(TextLabel.sub3)
                    .font(Font.pretendard(.medium, size: 16))
                    .frame(height: 11)
                
                Spacer()
                    .frame(height: 44)
                
                HStack {
                    Text("전체 약관 동의")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(TextLabel.main)
                    
                    Spacer()
                    
                    Button {
                        isChecked.toggle()
                    } label: {
                        Image(isChecked ? .checkboxActive : .checkboxInActive)
                    }
                }
                
                Spacer()
                    .frame(height: 24)
                
                HStack {
                    Text("(필수)서비스 이용 약관")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(TextLabel.sub2)
                    
                    Spacer()
                    
                    Button {
                        pathModel.paths.append(.terms)
                    } label: {
                        Image(.arrowRight)
                    }
                }
                
                Spacer()
                    .frame(height: 24)
                
                HStack {
                    Text("(필수)개인정보 처리방침")
                        .font(.pretendard(.semiBold, size: 16))
                        .foregroundStyle(TextLabel.sub2)
                    
                    Spacer()
                    
                    Button {
                        pathModel.paths.append(.privacy)
                    } label: {
                        Image(.arrowRight)
                    }
                }
                
                Spacer()
                    .frame(height: 48)
                
                ScrollView {
                    Text("""
                        저희 서비스는 모든 사용자가 안전하고 쾌적한 환경에서 활동할 수 있도록 불쾌한 콘텐츠 및 악의적인 사용자를 엄격히 제한합니다. 존중과 배려를 바탕으로 한 커뮤니티를 유지하기 위해 다음과 같은 약관을 적용합니다.
                        
                        1. 불법적인 활동: 불법적인 활동, 포르노그래피, 성적 차별, 혐오 발언, 폭력적인 콘텐츠 등을 포함한 어떠한 형태의 범죄적이거나 불쾌한 행위도 용납되지 않습니다.

                        2. 사생활 침해: 다른 사용자의 사생활을 침해하거나 불법적으로 개인 정보를 수집하거나 공유하는 행위는 엄격히 금지됩니다.

                        3. 악성 소프트웨어 및 스팸: 악성 소프트웨어의 전파, 스팸 홍보, 사기 행위 등과 같은 악의적인 소프트웨어 사용 또는 홍보는 금지됩니다.

                        4. 운영 정책 준수: 저희 서비스의 운영 정책 및 지침을 준수하지 않는 행위는 엄격히 금지되며, 이에 따른 조치가 취해질 수 있습니다.

                        5. 신고 및 조치: 사용자는 불쾌한 콘텐츠 또는 악의적인 사용자를 발견할 경우 즉시 신고할 수 있으며, 저희는 이를 검토하여 적절한 조치를 취할 것입니다.

                        이 약관을 위반할 경우 계정이 일시적으로 정지되거나 영구적으로 삭제될 수 있습니다. 저희는 모든 사용자가 안전하게 서비스를 이용할 수 있도록 최선을 다할 것을 약속드립니다.
                        """)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(TextLabel.sub3)
                    .lineSpacing(6)
                }
                
                Spacer()
                    .frame(height: 24)
                
                Spacer()
                
                ActionButton("다음", isActive: $isChecked, action: {
                    pathModel.paths.append(.signUpCompleted)
                })
                .animation(.easeIn, value: isChecked)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
        }
        .background(Background.first)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .alert("회원가입 실패", isPresented: $authViewModel.isSignUpFailedAlertPresented) {
            Button("확인", role: .none, action: {})
        } message: {
            Text("네트워크 또는 서버 문제로 회원가입에 실패했습니다. 다시 시도 또는 관리자에게 문의 해주세요.")
        }
    }
}

#Preview {
    SignUpTermsAgreementView()
        .environmentObject(PathModel())
        .environmentObject(AuthViewModel())
}
