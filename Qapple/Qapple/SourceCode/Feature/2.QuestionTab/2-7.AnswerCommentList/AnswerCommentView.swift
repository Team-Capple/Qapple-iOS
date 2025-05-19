//
//  AnswerCommentView.swift
//  Qapple
//
//  Created by 문인범 on 4/14/25.
//

import SwiftUI
import ComposableArchitecture

struct AnswerCommentView: View {
    @Bindable var store: StoreOf<AnswerCommentFeature>
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing: 0) {
            QPNavigationBar(
                title: "댓글",
                backgroundColor: Background.first,
                leadingView: {
                    QPNavigationButton(buttonType: .back) {
                        store.send(.backButtonTapped)
                    }
                }
            )
            
            QPAnswerCell(
                answer: store.answer,
                index: 0,
                state: .normal,
                seeMoreAction: {
                    store.send(.seeMoreAction)
                },
                likeAction: {
                    store.send(.likeAnswerButtonTapped)
                },
                commentAction: {}
            )
            .frame(width: screenWidth)
            .disabled(store.isLoading)
            
            CommentListView(store: store)
            
            Spacer()
            
            AddCommentView(store: store)
                .frame(width: screenWidth)
                .padding(.bottom, 8)

        }
        .background(Color.bk)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
        .popGestureEnabled(true)
        .onAppear {
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
    
    private var seperator: some View {
        Rectangle()
            .foregroundStyle(Color.placeholder)
            .frame(height: 1)
    }
}

// MARK: - CommentListView

private struct CommentListView: View {
    let store: StoreOf<AnswerCommentFeature>
    
    var body: some View {
        ZStack {
            VStack {
                seperator
                
                HStack {
                    Text("댓글")
                        .pretendard(.medium, 14)
                        .foregroundStyle(.sub3)
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal, 20)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // TODO: 4/14 데이터 연결 필요
    //                    ForEach(Array(self.store.commentList.enumerated()), id: \.offset) { index, comment in
    //                        AnswerCommentCell(
    //                            comment: comment,
    //                            like: {
    //                                store.send(.likeCommentButtonTapped(comment))
    //                            },
    //                            delete: {
    //                                store.send(.deleteCommentButtonTapped(comment))
    //                            },
    //                            report: {
    //                                store.send(.reportButtonTapped(comment))
    //                            }
    //                        )
    //                        .configurePagination(
    //                            store.commentList,
    //                            currentIndex: index,
    //                            hasNext: store.paginationInfo.hasNext,
    //                            pagination: {
    //                                store.send(.pagination)
    //                            }
    //                        )
    //                        .disabled(store.isLoading)
    //
    //                        seperator
    //                    }
                        
                        ForEach(AnswerCommentFeature.sampleComment) { comment in
                            AnswerCommentCell(
                                comment: comment,
                                like: {
                                    store.send(.likeCommentButtonTapped(comment))
                                },
                                delete: {
                                    store.send(.deleteCommentButtonTapped(comment))
                                },
                                report: {
                                    store.send(.reportButtonTapped(comment))
                                }
                            )
                            
                            seperator
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .background(Color.bk)
            
//            if store.commentList.isEmpty && !store.isLoading {
//                VStack {
//                    Text("아직 작성된 댓글이 없습니다")
//                        .font(.pretendard(.medium, size: 14))
//                        .foregroundStyle(.sub5)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 24)
//                    
//                    Spacer()
//                }
//            }
        }
    }
    
    private var seperator: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color.placeholder)
    }
}

// MARK: - AddCommentView

private struct AddCommentView: View {
    @Bindable var store: StoreOf<AnswerCommentFeature>
    
    var body: some View {
        HStack(alignment: .bottom) {
            TextField("댓글 추가", text: $store.commentText, axis: .vertical)
                .font(.pretendard(.regular, size: 17))
                .lineLimit(...3)
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button {
                store.send(.uploadCommentButtonTapped)
            } label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 20))
            }
            .tint(Color.wh)
            .padding(.trailing, 12)
            .padding(.bottom, 12)
            .disabled(store.commentText.isEmpty || store.isLoading )
        }
        .background {
            RoundedRectangle(cornerRadius: 11)
                .foregroundStyle(Color.placeholder)
        }
        .frame(minHeight: 50)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#Preview {
    AnswerCommentView(
        store: Store(
            initialState: AnswerCommentFeature.State(
                answer: Answer(
                    id: 1,
                    writerId: 1,
                    content: "특전사",
                    authorNickname: "이호창",
                    authorGeneration: "3기",
                    publishedDate: .init(),
                    isReported: false,
                    isMine: false,
                    isResignMember: false
                )
            )
        ){
        AnswerCommentFeature()
    })
}
