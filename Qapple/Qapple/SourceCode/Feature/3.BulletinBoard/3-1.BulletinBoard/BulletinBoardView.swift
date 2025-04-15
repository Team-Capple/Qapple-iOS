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
        ZStack(alignment: .bottom) {
            BulletinBoardContentView(store: store)
            
            NewBoardPostButton(store: store)
                .padding(.bottom, 20)
        }
        .background(.first)
        
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
            case .academySchedule: QPAcademyScheduleSheet()
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
            
            Button {
                store.send(.academyDayCounterTapped)
            } label: {
                QPAcademyDayCounter()
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
            }
            .buttonStyle(ScalableButtonStyle())
            
            BulletionBoardListView(store: store)
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 2)
        }
    }
}

// MARK: - QuestionNotificationView

private struct QuestionNotificationView: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        if !store.todayQuestion.isAnswered {
            Button {
                store.send(.questionNotiTapped(store.todayQuestion))
            } label: {
                HStack(spacing: 0) {
                    Image("questionReady")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 6)
                        .padding(.leading, 18)
                    
                    Text("오늘의 질문이 도착했어요!")
                        .font(.pretendard(.semiBold, size: 15))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .frame(width: 361, height: 47)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(.questionNoti)
                    .stroke(.button.opacity(0.17), lineWidth: 0.6)) // TODO: 그라데이션
            }
        } else {
            Button {
                store.send(.popularAnswerTapped(store.todayQuestion))
            } label: {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Image("questionComplete")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 8)
                            .padding(.leading, 18)
                        
                        Spacer()
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("오늘의 인기 답변")
                            .font(.pretendard(.regular, size: 12))
                            .foregroundStyle(TextLabel.sub4)
                        
                        Spacer()
                        
                        Text("프라이데이는 여자친구가 가지고 싶어요") // TODO: 인기 답변으로
                            .font(.pretendard(.regular, size: 15))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .frame(width: 361, height: 67)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(.questionNoti)
                    .stroke(.button.opacity(0.17), lineWidth: 0.6)) // TODO: 그라데이션
            }
        }
    }
}

// MARK: - BulletionBoardListView

private struct BulletionBoardListView: View {
    
    let store: StoreOf<BulletinBoardFeature>
    
    var body: some View {
        ScrollView {
            
            QuestionNotificationView(store: store)
                .padding(.horizontal)
                .padding(.top, 2)
            
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
                    .disabled(store.isLoading)
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
        .buttonStyle(ScalableButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    BulletinBoardView(store: Store(initialState: BulletinBoardFeature.State()) {
        BulletinBoardFeature()
    })
}
