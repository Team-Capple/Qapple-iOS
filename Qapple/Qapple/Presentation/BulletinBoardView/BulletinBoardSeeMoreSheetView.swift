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
    
    @EnvironmentObject private var pathModel: Router
    @EnvironmentObject private var bulletinBoardUseCase: BulletinBoardUseCase
    
    @State private var isRemovePostAlertPresented = false
    @State private var isRemoveCompleteAlertPresented = false
    
    let sheetType: SheetType
    let post: Post
    let isComment: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SeeMoreCellButton(
                title: sheetType.buttonTitle,
                isDestructive: true,
                tapAction: {
                    switch sheetType {
                    case .mine:
                        isRemovePostAlertPresented.toggle()
                    case .others:
                        dismiss()
                        pathModel.pushView(screen: BulletinBoardPathType.report(boardId: post.boardId, isComment: isComment))
                    }
                }
            )
        }
        .alert("게시글을 삭제할까요?", isPresented: $isRemovePostAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("삭제하기", role: .destructive) {
                bulletinBoardUseCase.effect(.removePost(postIndex: post.boardId))
                isRemoveCompleteAlertPresented.toggle()
            }
        } message: {
            Text("삭제 된 게시글은 복구할 수 없어요")
        }
        .alert("삭제가 완료됐어요", isPresented: $isRemoveCompleteAlertPresented) {
            Button("확인", role: .none) {
                dismiss()
                if isComment {
                    pathModel.pop()
                }
            }
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
                HapticManager.shared.notification(type: .success)
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
            boardId: 1,
            writerId: 2,
            writerNickname: "익명",
            content: "캐플짱",
            heartCount: 20,
            commentCount: 3,
            createAt: .now,
            isMine: true,
            isReported: false,
            isLiked: false
        ),
        isComment: false
    )
}
