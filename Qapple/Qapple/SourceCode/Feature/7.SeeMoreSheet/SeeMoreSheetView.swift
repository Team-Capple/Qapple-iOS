//
//  SeeMoreSheet.swift
//  Qapple
//
//  Created by 김민준 on 1/27/25.
//

import ComposableArchitecture
import SwiftUI

struct SeeMoreSheet: View {
    
    @Bindable var store: StoreOf<SeeMoreSheetFeature>
    
    var body: some View {
        ZStack {
            Color(Background.first)
                .ignoresSafeArea()
            
            VStack {
                switch store.sheetTarget {
                case .mine:
                    SeeMoreCell(title: "삭제하기") {
                        store.send(.deleteButtonTapped)
                    }
                    
                case .others:
                    SeeMoreCell(title: "신고하기") {
                        store.send(.reportButtonTapped(store.dataType))
                    }
                    
                    SeeMoreCell(title: "차단하기") {
                        store.send(.blockButtonTapped)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
        }
        .presentationDetents([ store.sheetTarget == .mine ? .height(80) : .height(120) ])
        .presentationDragIndicator(.visible)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - SeeMoreCell

private struct SeeMoreCell: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.warning)
            }
            
            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview

#Preview {
    SeeMoreSheet(
        store: Store(
            initialState: SeeMoreSheetFeature.State(
                sheetTarget: .others,
                dataType: .answer(.initialState)
            )
        ) {
            SeeMoreSheetFeature()
        }
    )
}
