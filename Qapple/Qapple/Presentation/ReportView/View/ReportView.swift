//
//  ReportView.swift
//  Capple
//
//  Created by 김민준 on 3/2/24.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var pathModel: Router
    @State private var isReportAlertPresented = false
    @State private var isReportCompleteAlertPresented = false
    @State private var reportType: ReportType = .DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS
    
    let answerId: Int
    
    var reportList = [
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
                            pathModel.pop()
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
                
                VStack(alignment: .leading) {
                    ForEach(Array(reportList.enumerated()), id: \.offset) { index, report in
                        Button {
                            reportType = ReportType.allCases[index]
                            isReportAlertPresented.toggle()
                            HapticManager.shared.notification(type: .warning)
                            print("신고타입: \(reportType)")
                        } label: {
                            Text(report)
                                .font(.pretendard(.medium, size: 16))
                                .foregroundStyle(.wh)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 48)
                                .background(Background.first)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    
                    Text("* 캐플은 모든 사용자가 안전하고 쾌적한 환경에서 서비스를 이용할 수 있도록 최선을 다하고 있어요. 그러나 이를 악용하여 다른 사용자에게 피해를 주는 경우, 제재가 가해질 수 있어요")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundStyle(TextLabel.sub3)
                        .lineSpacing(8)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .alert("답변을 신고하시겠어요?", isPresented: $isReportAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("신고하기", role: .destructive) {
                Task {
                    await requestReportAnswer()
                    isReportCompleteAlertPresented.toggle()
                    sendUpdateViewNotification()
                }
            }
        }
        .alert("신고가 완료됐어요", isPresented: $isReportCompleteAlertPresented) {
            Button("확인", role: .none) {
                // TODO: usecase를 불러와 isReported를 true로 바꿔야함
                // bulletinBoardUseCase.effect(.reportPost(postIndex: post.boardId))
                pathModel.pop()
            }
        } message: {
            Text("신고한 답변은 블라인드 처리 되며, 관리자 검토 후 최대 24시간 이내에 조치 될 예정이에요")
        }
    }
}

extension ReportView {
    
    /// 해당 답변을 신고합니다.
    @MainActor
    func requestReportAnswer() async {
        do {
            print("답변ID: \(answerId)\n신고타입: \(reportType)")
            let _ = try await NetworkManager.requestReport(
                request: .init(
                    answerId: answerId,
                    reportType: reportType.rawValue
                )
            )
        } catch {
            print("신고하기 실패")
        }
    }
    
    /// View 업데이트 Notification을 전송합니다.
    func sendUpdateViewNotification() {
        NotificationCenter.default.post(
            name: .updateViewNotification,
            object: nil
        )
    }
}

#Preview {
    ReportView(answerId: 1)
}
