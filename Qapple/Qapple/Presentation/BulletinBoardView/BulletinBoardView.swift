//
//  BulletinBoardView.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - BulletinBoardView

struct BulletinBoardView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
                .padding(.horizontal, 16)
            
            AcademyPlanDayCounter(
                currentEvent: "Prologue", // TODO: 실제 값
                progress: 0.47 // TODO: 실제 값
            )
            .padding(.top, 20)
            .padding(.horizontal, 22)
            
            Spacer()
        }
        .background(Background.first)
    }
}

// MARK: - NavigationBar

private struct NavigationBar: View {
    var body: some View {
        HStack(spacing: 24) {
            Text("자유게시판")
                .pretendard(.bold, 25)
                .foregroundStyle(.white)
            
            Spacer()
            
            CustomToolbarItem(
                buttonType: .search,
                tapAction: {
                    // TODO: 게시글 검색하기 View 이동
                }
            )
            
            CustomToolbarItem(
                buttonType: .plus,
                tapAction: {
                    // TODO: 게시글 작성하기 View 이동
                }
            )
        }
        .frame(height: 32)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BulletinBoardView()
    }
}
