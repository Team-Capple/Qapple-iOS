//
//  ReportView.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var pathModel: PathModel
    @State private var isReportAlertPresented = false
    @State private var isReportCompleteAlertPresented = false
    
    var moreList = [
        "불법촬영물 등의 유통",
        "상업적 광고 및 판매",
        "게시판 성격에 부적절함",
        "욕설/비하",
        "정당/정치인 비하 및 선거운동",
        "유출/사칭/사기",
        "낚시/놀림/도배"
    ]
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                CustomNavigationBar(
                    leadingView:{
                        CustomNavigationBackButton(buttonType: .arrow)  {
                            pathModel.paths.removeLast()
                        }
                    },
                    principalView: {
                        Text("신고하기")
                            .font(Font.pretendard(.semiBold, size: 15))
                            .foregroundStyle(TextLabel.main)
                    },
                    trailingView: {},
                    backgroundColor: .clear
                )
                
                VStack {
                    ForEach(moreList, id: \.self) { more in
                        Button {
                            isReportAlertPresented.toggle()
                            HapticManager.shared.notification(type: .warning)
                        } label: {
                            Text(more)
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(.wh)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 48)
                                .padding(.leading, 24)
                                .background(Background.first)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .alert("답변을 신고하시겠어요?", isPresented: $isReportAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("신고하기", role: .destructive) {
                isReportCompleteAlertPresented.toggle()
            }
        }
        .alert("신고가 완료됐어요", isPresented: $isReportCompleteAlertPresented) {
            Button("확인", role: .none) {
                pathModel.paths.removeLast()
            }
        } message: {
            Text("신고하신 내용을 빠르게 검토 후 조치할게요")
        }
    }
}

#Preview {
    ReportView()
}
