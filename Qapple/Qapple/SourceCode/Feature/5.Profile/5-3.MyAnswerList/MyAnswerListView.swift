//
//  MyAnswerListView.swift
//  Qapple
//
//  Created by Simmons on 2/2/25.
//

import SwiftUI
import ComposableArchitecture

struct MyAnswerListView: View {
    
    let store: StoreOf<MyAnswerListFeature>
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                QPNavigationBar(
                    title: "내 답변",
                    leadingView: {
                        QPNavigationButton(buttonType: .back) {
                            store.send(.backButtonTapped)
                        }
                    }
                )
                
                Spacer()
                
                MyAnswerList(store: store)
            }
            .loadingIndicator(isLoading: store.isLoading)
        }
        .background(.first)
        .navigationBarBackButtonHidden()
        .popGestureEnabled(true)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - MyAnswerList

private struct MyAnswerList: View {
    
    @Bindable var store: StoreOf<MyAnswerListFeature>
    
    var body: some View {
        if store.myAnswerList.isEmpty {
            HStack {
                Spacer()
                
                Text("작성한 답변이 없어요")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(TextLabel.sub3)
                    .opacity(store.isLoading ? 0 : 1)
                
                Spacer()
            }
            
            Spacer()
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(enumerated(store.myAnswerList), id: \.element.id) {
                        index, answer in
                        QPAnswerCell(
                            answer: answer,
                            index: index,
                            state: .written,
                            seeMoreAction:{
                                store.send(.seeMoreAction(answer))
                            },
                            likeAction: {
                                store.send(.likeAnswerButtonTapped(answer))
                            },
                            commentAction: {
                                store.send(.commentButtonTapped(answer))
                            }
                        )
                        .configurePagination(
                            store.myAnswerList,
                            currentIndex: index,
                            hasNext: store.paginationInfo.hasNext,
                            pagination: {
                                store.send(.pagination)
                            }
                        )
                    }
                }
            }
            .refreshable {
                store.send(.refresh)
            }
            .sheet(item: $store.scope(state: \.sheet, action: \.sheet)
            ) { store in
                switch store.case {
                case let .seeMore(store): SeeMoreSheet(store: store)
                }
            }
        }
    }
}

#Preview {
    MyAnswerListView(store: Store(initialState: MyAnswerListFeature.State()) {
        MyAnswerListFeature()
    })
}
