//
//  BulletinBoardTests.swift
//  QappleTests
//
//  Created by Simmons on 3/3/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import Qapple

@MainActor
struct BulletinBoardTests {
    
    let testPaginationInfo = QappleAPI.PaginationInfo(threshold: "", hasNext: true)
    
    let testBulletinBoardList = [
        BulletinBoard(id: 1, writerId: 1, writerNickname: "1번", content: "첫 번째 테스트 게시글", heartCount: 3, commentCount: 5, createAt: .now, isMine: false, isReported: false, isLiked: false),
        BulletinBoard(id: 2, writerId: 2, writerNickname: "2번", content: "두 번째 테스트 게시글", heartCount: 10, commentCount: 2, createAt: .now, isMine: true, isReported: false, isLiked: true),
        BulletinBoard(id: 3, writerId: 3, writerNickname: "3번", content: "세 번째 테스트 게시글", heartCount: 0, commentCount: 1, createAt: .now, isMine: false, isReported: true, isLiked: false)
    ]
    
    @Test("게시판리스트 첫 화면 테스트")
    func OnAppear() async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        } withDependencies: {
            $0.bulletinBoardRepository.fetchBulletinBoardList = { _ in
                (testBulletinBoardList, testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off

        await store.send(.onAppear)
        await store.receive(\.bulletinBoardListResponse) {
            $0.isFirstLaunch = false
            $0.bulletinBoardList = testBulletinBoardList
            $0.paginationInfo = testPaginationInfo
        }
    }
    
    @Test("게시판 페이지네이션 테스트")
    func pagination() async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        } withDependencies: {
            $0.bulletinBoardRepository.fetchBulletinBoardList = { _ in
                (testBulletinBoardList, testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.send(.pagination)
        await store.receive(\.paginationResponse) {
            $0.bulletinBoardList = testBulletinBoardList + testBulletinBoardList
            $0.paginationInfo = testPaginationInfo
        }
    }
    
    @Test("네트워킹 실패 테스트")
    func networkingFailed() async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        } withDependencies: {
            $0.bulletinBoardRepository.fetchBulletinBoardList = { _ in
                throw TestError.networkingError
            }
            $0.bulletinBoardRepository.likeBoard = { _ in
                throw TestError.networkingError
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.networkingFailed) {
            $0.alert = .failedNetworking(with: TestError.networkingError)
        }
        await store.send(.pagination)
        await store.receive(\.networkingFailed) {
            $0.alert = .failedNetworking(with: TestError.networkingError)
        }
        
        await store.send(.likeBoardButtonTapped(testBulletinBoardList.first!))
        await store.receive(\.networkingFailed) {
            $0.alert = .failedNetworking(with: TestError.networkingError)
        }
    }
    
    @Test("신고 여부에 따른 게시글 Cell 테스트", arguments: [
        BulletinBoard(id: 1, writerId: 1, writerNickname: "1번", content: "첫 번째 테스트 게시글", heartCount: 3, commentCount: 5, createAt: .now, isMine: false, isReported: false, isLiked: false),
        BulletinBoard(id: 2, writerId: 2, writerNickname: "2번", content: "두 번째 테스트 게시글", heartCount: 10, commentCount: 2, createAt: .now, isMine: true, isReported: true, isLiked: true)
    ])
    func bulletinBoardCellTapped(argument: BulletinBoard) async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        } withDependencies: {
            $0.bulletinBoardRepository.fetchBulletinBoardList = { _ in
                ([argument], testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.bulletinBoardListResponse)
        if store.state.bulletinBoardList.first!.isReported {
            await store.send(.reportButtonTapped){
                $0.alert = .confirmReport
            }
        }
    }
    
    @Test("게시글 좋아요 버튼 테스트", arguments: [
        BulletinBoard(id: 1, writerId: 1, writerNickname: "1번", content: "첫 번째 테스트 게시글", heartCount: 3, commentCount: 5, createAt: .now, isMine: false, isReported: false, isLiked: false),
        BulletinBoard(id: 2, writerId: 2, writerNickname: "2번", content: "두 번째 테스트 게시글", heartCount: 10, commentCount: 2, createAt: .now, isMine: true, isReported: true, isLiked: true)
    ])
    func likeBoardButtonTapped(argument: BulletinBoard) async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        } withDependencies: {
            $0.bulletinBoardRepository.fetchBulletinBoardList = { _ in
                ([argument], testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.bulletinBoardListResponse)
        
        let board = store.state.bulletinBoardList.first!
        
        let boardId = board.id
        let originalHeartCount = board.heartCount
        let originalIsLiked = board.isLiked
        
        await store.send(.likeBoardButtonTapped(argument))
        await store.receive(\.likeBoard) {
            if let index = $0.bulletinBoardList.firstIndex(where: { $0.id == boardId }) {
                $0.bulletinBoardList[index].isLiked = !originalIsLiked
                $0.bulletinBoardList[index].heartCount = originalHeartCount + (originalIsLiked ? -1 : 1)
            }
        }
    }
    
    @Test("게시글 더보기 버튼 테스트", arguments: [
        BulletinBoard(id: 1, writerId: 1, writerNickname: "나", content: "내 게시글", heartCount: 3, commentCount: 5, createAt: .now, isMine: true, isReported: false, isLiked: false),
        BulletinBoard(id: 2, writerId: 2, writerNickname: "상대", content: "다른 사람 게시글", heartCount: 10, commentCount: 2, createAt: .now, isMine: false, isReported: false, isLiked: true)
    ])
    func seeMoreActionTest(argument: BulletinBoard) async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        }
        
        await store.send(.seeMoreAction(argument)) {
            $0.sheet = .seeMore(
                .init(
                    sheetTarget: argument.isMine ? .mine : .others,
                    dataType: .bulletinBoard(argument)
                )
            )
        }
    }
    
    @Test("게시글 삭제 버튼 테스트")
    func deleteBoardTest() async throws {
        let store = TestStore(initialState: .init()) {
            BulletinBoardFeature()
        } withDependencies: {
            $0.bulletinBoardRepository.fetchBulletinBoardList = { _ in
                (testBulletinBoardList, testPaginationInfo)
            }
        }
        
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(\.bulletinBoardListResponse)
        
        let board = store.state.bulletinBoardList.first!

        await store.send(.deleteBoard(board.id)) {
            $0.bulletinBoardList.removeAll { $0.id == board.id }
        }
    }
}

