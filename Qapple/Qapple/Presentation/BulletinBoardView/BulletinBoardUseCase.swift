//
//  BulletinBoardUseCase.swift
//  Qapple
//
//  Created by 김민준 on 8/10/24.
//

import Foundation
import Combine

final class BulletinBoardUseCase: ObservableObject {
    
    @Published var state: State
    @Published var isClickComment: Bool = false
    @Published var isLoading: Bool = false
    @Published var searchText = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
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
            searchHasNext: false,
            hasNext: false
        )
        
        // 검색 로직
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard !query.isEmpty else { return }
                
                Task {
                    @MainActor in
                    self?.searchPost(keyword: query)
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
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
        var searchTheshold: Int?
        var threshold: Int?
        var searchHasNext: Bool
        var hasNext: Bool
    }
}

// MARK: - Effect

extension BulletinBoardUseCase {
    
    enum Effect {
        case fetchPost
        case refreshPost
        case searchPost(keyword: String)
        case refreshSearchPost(keyword: String)
        case likePost(postId: Int)
        case removePost(postIndex: Int)
        case reportPost(postIndex: Int)
        case fetchSinglePost(postId: Int)
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
            
        case .refreshSearchPost(let keyword):
            Task {
                await refreshSearchPost(keyword: keyword)
                print("게시판 검색 리프레쉬")
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
            
        case .fetchSinglePost(postId: let postId):
            if let index = state.posts.firstIndex(where: { $0.boardId == postId }) {
                Task{
                    await fetchSinglePost(boardId: postId, index: index)
                }
            }
        }
    }
}
// MARK: - fetch

extension BulletinBoardUseCase {
    
    @MainActor
    func reset() {
        state.searchTheshold = nil
        state.threshold = nil
        state.searchHasNext = false
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
                        threshold: state.threshold,
                        pageSize: 25 // 한번 불러올 때 25개 씩
                    )
                )
                
                let postList: [Post] = boardList.content.map { board in
                    Post(
                        boardId: board.boardId,
                        writerId: board.writerId,
                        writerNickname: board.writerNickname,
                        content: board.content,
                        heartCount: board.heartCount,
                        commentCount: board.commentCount,
                        createAt: board.createdAt.ISO8601ToDate,
                        isMine: board.isMine,
                        isReported: board.isReported,
                        isLiked: board.isLiked
                    )
                }
                
                state.posts += postList
                state.threshold = Int(boardList.threshold)
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
        state.threshold = nil
        state.hasNext = false
        
        Task {
            do {
                let boardList = try await NetworkManager.fetchBoard(
                    .init(
                        threshold: state.threshold,
                        pageSize: 25 // 한번 불러올 때 25개 씩
                    )
                )
                
                let postList: [Post] = boardList.content.map { board in
                    Post(
                        boardId: board.boardId,
                        writerId: board.writerId,
                        writerNickname: board.writerNickname,
                        content: board.content,
                        heartCount: board.heartCount,
                        commentCount: board.commentCount,
                        createAt: board.createdAt.ISO8601ToDate,
                        isMine: board.isMine,
                        isReported: board.isReported,
                        isLiked: board.isLiked
                    )
                }
                
                state.posts.removeAll()
                state.posts += postList
                state.threshold = Int(boardList.threshold)
                state.hasNext = boardList.hasNext
                print("리프레쉬 성공")
                self.isLoading = false
            } catch {
                print("게시판 업데이트 실패")
                self.isLoading = false
            }
        }
    }
// MARK: - Search
    
    @MainActor
    func searchPost(keyword: String) {
        Task {
            do {
                let searchPostList = try await NetworkManager.fetchBoardOfSearch(
                    .init(
                        keyword: keyword,
                        threshold: state.searchTheshold,
                        pageSize: 25
                    )
                )
                
                let searchList: [Post] = searchPostList.content.map { search in
                    Post(
                        boardId: search.boardId,
                        writerId: search.writerId,
                        writerNickname: search.writerNickname,
                        content: search.content,
                        heartCount: search.heartCount,
                        commentCount: search.commentCount,
                        createAt: search.createdAt.ISO8601ToDate,
                        isMine: search.isMine,
                        isReported: search.isReported,
                        isLiked: search.isLiked
                    )
                }
                
                state.searchPosts += searchList
                state.searchTheshold = Int(searchPostList.threshold)
                state.searchHasNext = searchPostList.hasNext
                print(state.searchHasNext)
            } catch {
                print(error.localizedDescription)
                print("게시판 검색 실패")
            }
        }
    }
    
    @MainActor
    func refreshSearchPost(keyword: String) {
        
        state.searchTheshold = nil
        state.searchHasNext = false
        
        Task {
            do {
                let searchPostList = try await NetworkManager.fetchBoardOfSearch(
                    .init(
                        keyword: keyword,
                        threshold: state.searchTheshold,
                        pageSize: 25
                    )
                )
                
                let searchList: [Post] = searchPostList.content.map { search in
                    Post(
                        boardId: search.boardId,
                        writerId: search.writerId,
                        writerNickname: search.writerNickname,
                        content: search.content,
                        heartCount: search.heartCount,
                        commentCount: search.commentCount,
                        createAt: search.createdAt.ISO8601ToDate,
                        isMine: search.isMine,
                        isReported: search.isReported,
                        isLiked: search.isLiked
                    )
                }
                
                state.searchPosts.removeAll()
                state.searchPosts += searchList
                state.searchTheshold = Int(searchPostList.threshold)
                state.searchHasNext = searchPostList.hasNext
                print("검색 리프레쉬 성공")
            } catch {
                print(error.localizedDescription)
                print("검색 리프레쉬 실패")
            }
        }
    }

// MARK: - SingleFetch
   
    @MainActor
    private func fetchSinglePost(boardId: Int, index: Int) {
        Task {
            do {
                let singleBoard = try await NetworkManager.fetchSingleBoard(.init(boardId: boardId))
                
                let changeBoard: Post =
                    Post(
                        boardId: singleBoard.boardId,
                        writerId: singleBoard.writerId,
                        writerNickname: singleBoard.writerNickname,
                        content: singleBoard.content,
                        heartCount: singleBoard.heartCount,
                        commentCount: singleBoard.commentCount,
                        createAt: singleBoard.createdAt.ISO8601ToDate,
                        isMine: singleBoard.isMine,
                        isReported: singleBoard.isReported,
                        isLiked: singleBoard.isLiked
                    )
                
                state.posts[index] = changeBoard
            } catch {
                print("단건 게시판 업데이트 실패")
            }
        }
    }
}
