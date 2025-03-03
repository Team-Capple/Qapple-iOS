//
//  BulletinBoardView.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - BulletinBoardView

struct BulletinBoardView: View {
    
    @Bindable var store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                BulletinBoardContentView(store: store)
                
                NewBoardPostButton(store: store)
                .position(
                    CGPoint(
                        x: proxy.size.width / 2,
                        y: proxy.size.height - 40
                    )
                )
            }
            .background(Background.first)
        }
        .onAppear{
            store.send(.onAppear)
        }
        .refreshable {
            store.send(.refresh)
        }
        .loadingIndicator(isLoading: store.isLoading)
        .sheet(item: $store.scope(state: \.sheet, action: \.sheet)
        ) { store in
            switch store.case {
            case let .seeMore(store): SeeMoreSheet(store: store)
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - BulletinBoardContentView

private struct BulletinBoardContentView: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            QPNavigationBar(
                title: "게시판",
                trailingView: {
                    HStack(spacing: 12) {
                        QPNavigationButton(buttonType: .image(.noticeIcon)) {
                            store.send(.notificationButtonTapped)
                        }
                        QPNavigationButton(buttonType: .image(.search)) {
                            store.send(.searchButtonTapped)
                        }
                    }
                    .padding(.trailing, 8)
                }
            )
            
            QPAcademyDayCounter()
                .padding(.top, 8)
                .padding(.horizontal, 16)
            
            BulletionBoardListView(store: store)
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 2)
        }
    }
}

// MARK: - BulletionBoardListView

private struct BulletionBoardListView: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(enumerated(store.bulletinBoardList), id: \.offset) { index, board in
                    Button {
                        if !board.isReported {
                            store.send(.boardCellTapped(board))
                        } else {
                            store.send(.reportButtonTapped)
                        }
                    } label: {
                        BulletinBoardCell(
                            board: board,
                            seeMore: {
                                store.send(.seeMoreAction(board))
                            },
                            like: {
                                store.send(.likeBoardButtonTapped(board))
                            }
                        )
                    }
                    .configurePagination(
                        store.bulletinBoardList,
                        currentIndex: index,
                        hasNext: store.paginationInfo.hasNext,
                        pagination: {
                            store.send(.pagination)
                        }
                    )
                    if index != store.bulletinBoardList.endIndex - 1 {
                        QPDivider()
                    }
                }
            }
        }
    }
}

// MARK: - NewBoardPostButton

struct NewBoardPostButton: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        Button {
            store.send(.postBoardButtonTapped)
        } label: {
            Text("게시글 작성")
                .font(.pretendard(.semiBold, size: 17))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 11)
                .frame(width: 161, height: 47)
                .background(.regularMaterial)
                .cornerRadius(32)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(.white.opacity(0.5), lineWidth: 0.33)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardView(store: Store(initialState: BulletinBoardFeature.State()) {
        BulletinBoardFeature()
    })
}
