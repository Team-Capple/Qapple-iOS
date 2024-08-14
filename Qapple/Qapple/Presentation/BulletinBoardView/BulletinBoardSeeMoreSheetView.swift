//
//  BulletinBoardSeeMoreSheetView.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import SwiftUI

// MARK: - BulletinBoardSeeMoreSheetView

struct BulletinBoardSeeMoreSheetView: View {
    
    enum SheetType {
        case mine
        case others
        
        var buttonTitle: String {
            switch self {
            case .mine: return "삭제하기"
            case .others: return "신고하기"
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @State private var isRemovePostAlertPresented = false
    
    let sheetType: SheetType
    let post: Post
    
    var body: some View {
        VStack(spacing: 0) {
            SeeMoreCellButton(
                title: sheetType.buttonTitle,
                isDestructive: true,
                tapAction: {
                    switch sheetType {
                    case .mine: isRemovePostAlertPresented.toggle()
                    case .others: break // TODO: 신고하기 View 이동
                    }
                }
            )
        }
        .alert("게시글을 삭제할까요?", isPresented: $isRemovePostAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("삭제하기", role: .destructive) {
                bulletinBoardUseCase.effect(.removePost(postIndex: post.anonymityIndex))
                dismiss()
            }
        } message: {
            Text("삭제 된 게시글은 복구할 수 없어요")
        }
        .onAppear {
            print("현재 선택된 포스트: \(post.content)")
        }
    }
}

// MARK: - SeeMoreCell

private struct SeeMoreCellButton: View {
    
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    let title: String
    let isDestructive: Bool
    let tapAction: () -> Void
    
    var body: some View {
        HStack {
            Button {
                tapAction()
            } label: {
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(isDestructive ? Context.warning : TextLabel.main)
            }
            .padding(.leading, 20)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardSeeMoreSheetView(
        sheetType: .others,
        post: Post(
            anonymityIndex: 1,
            isMine: true,
            content: "오늘 날씨가 정말 좋네요!",
            isLike: true,
            likeCount: 10,
            commentCount: 2,
            writingDate: Date()
        )
    )
}
