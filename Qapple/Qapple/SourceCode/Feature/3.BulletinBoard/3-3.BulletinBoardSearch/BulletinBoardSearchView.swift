//
//  BulletinBoardSearchView.swift
//  Qapple
//
//  Created by Simmons on 1/29/25.
//

import SwiftUI
import ComposableArchitecture

struct BulletinBoardSearchView: View {
    
    @Bindable var store: StoreOf<BulletinBoardSearchFeature>
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    QPNavigationBar(
                        title: "검색하기",
                        backgroundColor: Background.first,
                        leadingView: {
                            QPNavigationButton(buttonType: .back) {
                                store.send(.backButtonTapped)
                            }
                        }
                    )
                    
                    SearchBar(store: store)
                        .padding(.horizontal, 16)
                    
                    if !store.searchBoardList.isEmpty {
                        SearchListView(store: store)
                    } else {
                        NoResultView()
                    }
                }
            }
            .background(Background.first)
            .navigationBarBackButtonHidden()
            .popGestureEnabled(true)
        }
        .onAppear {
            if !store.searchText.isEmpty {
                store.send(.onAppear)
            }
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
        .onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - SearchBar

private struct SearchBar: View {
    
    @Bindable var store: StoreOf<BulletinBoardSearchFeature>
    
    var body: some View {
        HStack(spacing: 6) {
            TextField("검색어를 입력해주세요", text: $store.searchText) {}
                .pretendard(.semiBold, 15)
                .onChange(of: store.searchText) {
                    store.send(.searchTextChanged)
                }
        }
        .padding(14)
        .background(GrayScale.secondaryButton)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - SearchListView

private struct SearchListView: View {
    
   let store: StoreOf<BulletinBoardSearchFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(enumerated(store.searchBoardList), id: \.offset) { index, board in
                    Button {
                        store.send(.boardCellTapped(board))
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
                        store.searchBoardList,
                        currentIndex: index,
                        hasNext: store.paginationInfo.hasNext,
                        pagination: {
                            store.send(.pagination)
                        }
                    )
                    .disabled(store.isLoading)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

// MARK: - NoResultView

private struct NoResultView: View {
    var body: some View {
        VStack {
            Text("검색 결과가 없어요")
                .font(Font.pretendard(.medium, size: 14))
                .foregroundStyle(TextLabel.sub4)
                .padding(.top, 24)
            
            Spacer()
        }
    }
}

#Preview {
    BulletinBoardSearchView(store: Store(initialState: BulletinBoardSearchFeature.State()){
        BulletinBoardSearchFeature()
    })
}
