//
//  BulletinBoardCell.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - BulletinBoardCell

struct BulletinBoardCell: View {
    
    let board: BulletinBoard
    let seeMore: () -> Void
    let like: () -> Void
    
    var body: some View {
        if board.isMine {
            NormalBoardCell(
                board: board,
                seeMore: seeMore,
                like: like
            )
        } else {
            if board.isReported {
                ReportBoardCell(
                    board: board,
                    like: like
                )
            } else {
                NormalBoardCell(
                    board: board,
                    seeMore: seeMore,
                    like: like
                )
            }
        }
    }
}
// MARK: - NormalBoardCell

private struct NormalBoardCell: View {
    
    let board: BulletinBoard
    let seeMore: () -> Void
    let like: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(
                board: board,
                seeMore: seeMore
            )
            .padding(.top)
            .padding(.horizontal)
            
            ContentView(
                board: board,
                like: like
            )
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            Divider()
                .padding(.top, 24)
        }
        .background(Background.first)
    }
}


// MARK: - HeaderView

private struct HeaderView: View {
    
    let board: BulletinBoard
    let seeMore: () -> Void
    
    private var nickname: String {
        if board.writerNickname == "알 수 없음" {
            return "(알 수 없음)"
        } else {
            return "익명의 러너"
        }
    }
    
    private var generation: String {
        if board.writerGeneration == "" {
            return "3기"
        } else {
            return board.writerGeneration
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.profileDummy)
                .resizable()
                .frame(width: 28, height: 28)
            
            Text(nickname)
                .pretendard(.semiBold, 14)
                .foregroundStyle(GrayScale.icon)
                .padding(.leading, 8)
            
            Text(generation)
                .pretendard(.medium, 10)
                .foregroundStyle(TextLabel.main)
                .frame(width: 32, height: 17)
                .background(
                    RoundedRectangle(cornerRadius: 19)
                        .fill(.secondaryButton)
                )
                .padding(.leading, 8)
            
            Text("\(board.createAt.timeAgo)")
                .pretendard(.regular, 12)
                .foregroundStyle(TextLabel.sub4)
                .padding(.leading, 6)
            
            Spacer()
            
            Button {
                seeMore()
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(GrayScale.icon)
            }
        }
    }
}

// MARK: - ContentView

private struct ContentView: View {
    
    let board: BulletinBoard
    let like: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .foregroundStyle(.clear)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(board.content)
                    .pretendard(.medium, 16)
                    .foregroundStyle(TextLabel.main)
                    .padding(.top, 2)
                    .multilineTextAlignment(.leading)
                
                RemoteView(
                    board: board,
                    like: like
                )
                .padding(.top, 16)
                .disabled(board.isReported)
            }
        }
    }
}

// MARK: - RemoteView

private struct RemoteView: View {
    
    let board: BulletinBoard
    let like: () -> Void
    
    var body: some View {
        HStack {
            Button {
                like()
            } label: {
                HStack(spacing: 4) {
                    Image(board.isLiked ? .heartActive : .heart)
                    
                    Text("\(board.heartCount)")
                        .pretendard(.regular, 13)
                        .foregroundStyle(TextLabel.sub3)
                }
            }
            
            HStack(spacing: 4) {
                Image(systemName: "text.bubble.fill")
                    .resizable()
                    .frame(width: 15, height: 14)
                    .foregroundStyle(TextLabel.sub3)
                
                Text("\(board.commentCount)")
                    .pretendard(.regular, 13)
                    .foregroundStyle(TextLabel.sub3)
            }
        }
    }
}

// MARK: - ReportBoardCell

private struct ReportBoardCell: View {

    @State private var isReportContentShow = false

    let board: BulletinBoard
    let like: () -> Void

    var body: some View {
        Group {
            if !isReportContentShow {
                ReportHideView(isReportContentShow: $isReportContentShow)
            } else {
                ReportShowView(
                    isReportContentShow: $isReportContentShow,
                    board: board,
                    like: like
                )
            }
        }
        .opacity(0.5)
    }
}

// MARK: - ReportShowView

private struct ReportShowView: View {
    
    @Binding private(set) var isReportContentShow: Bool
    
    let board: BulletinBoard
    let like: () -> Void
    
    private var nickname: String {
        if board.writerNickname == "알 수 없음" {
            return "(알 수 없음)"
        } else {
            return "익명의 러너"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Image(.profileDummy)
                    .resizable()
                    .frame(width: 28, height: 28)

                Text(nickname)
                    .pretendard(.semiBold, 14)
                    .foregroundStyle(GrayScale.icon)
                    .padding(.leading, 8)

                Text("\(board.createAt.timeAgo)")
                    .pretendard(.regular, 14)
                    .foregroundStyle(TextLabel.sub4)
                    .padding(.leading, 6)

                Spacer()

                Button {
                    isReportContentShow.toggle()
                } label: {
                    Text("게시글 숨기기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(BrandPink.text)
                }
            }
            .padding(.horizontal, 16)

            ContentView(
                board: board,
                like: like
            )
                .padding(.horizontal, 16)
        }
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(Background.first)
    }
}

// MARK: - ReportHideView

private struct ReportHideView: View {
    
    @Binding private(set) var isReportContentShow: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("신고 되어 내용을 검토 중인 게시글이에요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.sub3)
                
                Spacer()
                
                Button {
                    isReportContentShow.toggle()
                } label: {
                    Text("게시글 보기")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(BrandPink.text)
                }
            }
            .frame(height: 28)
            .padding(.horizontal, 16)

            HStack {
                Text("주의) 부적절한 콘텐츠가 포함될 수 있어요")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(TextLabel.sub4)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 20)
        .padding(.bottom, 26)
        .background(Background.first)
    }
}
