//
//  ReportView.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import ComposableArchitecture
import QappleRepository
import SwiftUI

struct ReportView: View {
    
    @Bindable var store: StoreOf<ReportFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            QPNavigationBar(
                title: "신고하기",
                leadingView: {
                    QPNavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                }
            )
            
            ReportList(store: store)
                .padding(.top, 12)
                .disabled(store.isLoading)
            
            Text("* 캐플은 모든 사용자가 안전하고 쾌적한 환경에서 서비스를 이용할 수 있도록 최선을 다하고 있어요. 그러나 이를 악용하여 다른 사용자에게 피해를 주는 경우, 제재가 가해질 수 있어요")
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(.sub3)
                .lineSpacing(8)
                .padding(.top, 20)
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureEnabled(true)
        .loadingIndicator(isLoading: store.isLoading)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - ReportList

private struct ReportList: View {
    
    let store: StoreOf<ReportFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(ReportType.allCases, id: \.rawValue) { reportType in
                Button {
                    store.send(.reportCellTapped(reportType))
                } label: {
                    Text(reportType.toString)
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.wh)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 48)
                        .padding(.horizontal, 24)
                }
                .disabled(store.isLoading)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ReportView(store: Store(initialState: .init(dataType: .answer(.initialState))) {
        ReportFeature()
    })
}
