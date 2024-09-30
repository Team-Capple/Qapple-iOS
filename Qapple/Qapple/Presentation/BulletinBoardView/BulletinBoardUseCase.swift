//
//  BulletinBoardUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation

final class BulletinBoardUseCase: ObservableObject {
    
    @Published var state: State
    @Published var isClickComment: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
        
        // 매크로 시작 날
        var startDateComponents = DateComponents()
        startDateComponents.year = 2024
        startDateComponents.month = 9
        startDateComponents.day = 2
        
        // 매크로 종료 날
        var endDateComponents = DateComponents()
        endDateComponents.year = 2024
        endDateComponents.month = 11
        endDateComponents.day = 29
        
        let calendar = Calendar.current
        
        self.state = State(
            currentEvent: "Macro",
            startDate: calendar.date(from: startDateComponents)!,
            endDate: calendar.date(from: endDateComponents)!,
            posts: [],
            searchPosts: [],
            pageNumber: 0,
            hasPrevious: false,
            hasNext: false
        )
    }
}

// MARK: - State

extension BulletinBoardUseCase {
    
    struct State {
        let currentEvent: String
        let startDate: Date
        let endDate: Date
        var posts: [Post]
        var searchPosts: [Post]
        var pageNumber: Int
        var hasPrevious: Bool
        var hasNext: Bool
    }
}

// MARK: - Effect

extension BulletinBoardUseCase {
    
    enum Effect {
        case fetchPost
        case refreshPost
        case searchPost(keyword: String)
        case likePost(postId: Int)
        case removePost(postIndex: Int)
        case reportPost(postIndex: Int)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .fetchPost:
            Task {
                await fetchPostList()
                print("게시판 업데이트")
            }
            
        case .refreshPost:
            Task {
                await refreshPostList()
                print("게시판 리프레쉬")
            }
            
        case .searchPost(let keyword):
            Task {
                await searchPost(keyword: keyword)
                print("게시판 검색")
            }
            
        case .likePost(let postId):
            if let index = state.posts.firstIndex(where: { $0.boardId == postId }) {
                print("\(index)번째 게시글 좋아요 업데이트")
                self.isLoading = true
                
                state.posts[index].isLiked.toggle()
                state.posts[index].heartCount += state.posts[index].isLiked ? 1 : -1
                
                // 서버로 좋아요 요청 보내기
                Task {
                    do {
                        let _ = try await NetworkManager.requestLikeBoard(.init(boardId: postId))
                    } catch {
                        // 오류 발생 시 다시 상태 복구
                        DispatchQueue.main.async { [self] in
                            state.posts[index].isLiked.toggle()
                            state.posts[index].heartCount += state.posts[index].isLiked ? 1 : -1
                        }
                        print("Error updating like for post \(postId): \(error)")
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
            
        case .removePost(postIndex: let postIndex):
            print("\(postIndex)번째 게시글 삭제")
            if let index = state.posts.firstIndex(where: { $0.boardId == postIndex }) {
                state.posts.remove(at: index)
            }
            Task {
                do {
                    let _ = try await NetworkManager.requestDeleteBoard(.init(boardId: postIndex))
                } catch {
                    print(error)
                }
            }
            
        case .reportPost(postIndex: let postIndex):
            print("\(postIndex)번째 게시글 신고")
        }
    }
}
// MARK: - fetch

extension BulletinBoardUseCase {
    
    @MainActor
    func reset() {
        state.pageNumber = 0
        state.hasPrevious = false
        state.hasNext = false
        state.posts.removeAll()
    }
    
    @MainActor
    private func fetchPostList() {
        self.isLoading = true
        
        Task {
            do {
                let boardList = try await NetworkManager.fetchBoard(
                    .init(
                        pageNumber: state.pageNumber,
                        pageSize: 25 // 한번 불러올 때 25개 씩
                    )
                )
                
                let postList: [Post] = boardList.content.map { board in
                    Post(
                        boardId: board.boardId,
                        writerId: board.writerId,
                        content: board.content,
                        heartCount: board.heartCount,
                        commentCount: board.commentCount,
                        createAt: board.createAt.ISO8601ToDate,
                        isMine: board.isMine,
                        isReported: board.isReported,
                        isLiked: board.isLiked
                    )
                }
                
                state.posts += postList
                state.pageNumber += 1
                state.hasPrevious = boardList.hasPrevious
                state.hasNext = boardList.hasNext
                self.isLoading = false
            } catch {
                print("게시판 업데이트 실패")
                self.isLoading = false
            }
        }
    }
    
    @MainActor
    func refreshPostList() {
        self.isLoading = true
        
        /// 초기화
        state.pageNumber = 0
        state.hasPrevious = false
        state.hasNext = false
        
        Task {
            do {
                let boardList = try await NetworkManager.fetchBoard(
                    .init(
                        pageNumber: state.pageNumber,
                        pageSize: 25 // 한번 불러올 때 25개 씩
                    )
                )
                
                let postList: [Post] = boardList.content.map { board in
                    Post(
                        boardId: board.boardId,
                        writerId: board.writerId,
                        content: board.content,
                        heartCount: board.heartCount,
                        commentCount: board.commentCount,
                        createAt: board.createAt.ISO8601ToDate,
                        isMine: board.isMine,
                        isReported: board.isReported,
                        isLiked: board.isLiked
                    )
                }
                
                state.posts.removeAll()
                state.posts += postList
                state.pageNumber += 1
                state.hasPrevious = boardList.hasPrevious
                state.hasNext = boardList.hasNext
                print("리프레쉬 성공")
                self.isLoading = false
            } catch {
                print("게시판 업데이트 실패")
                self.isLoading = false
            }
        }
    }
    
    @MainActor
    func searchPost(keyword: String) {
        Task {
            do {
                let searchPostList = try await NetworkManager.fetchBoardOfSearch(
                    .init(
                        keyword: keyword,
                        pageNumber: 0,
                        pageSize: 1000
                    )
                )
                 
                self.state.searchPosts = searchPostList.content.map {
                    Post(
                        boardId: $0.boardId,
                        writerId: $0.writerId,
                        content: $0.content,
                        heartCount: $0.heartCount,
                        commentCount: $0.commentCount,
                        createAt: $0.createAt.ISO8601ToDate,
                        isMine: $0.isMine,
                        isReported: $0.isReported,
                        isLiked: $0.isLiked
                    )
                }
            } catch {
                print("게시판 검색 실패")
            }
        }
    }
}
