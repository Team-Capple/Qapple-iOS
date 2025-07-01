//
//  ReportRepository.swift
//  Qapple
//
//  Created by 김민준 on 2/6/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation

struct ReportRepository {
    var reportAnswer: (_ answerId: Int, _ reportType: ReportType) async throws -> Void
    var reportBoard: (_ boardId: Int, _ reportType: ReportType) async throws -> Void
    var reportBoardComment: (_ commentId: Int, _ reportType: ReportType) async throws -> Void
    var reportAnswerComment:(_ commentId: Int, _ reportType: ReportType) async throws -> Void
}

// MARK: - DependencyKey

extension ReportRepository: DependencyKey {
    
    static let liveValue = Self(
        reportAnswer: { answerId, reportType in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await ReportAPI.reportAnswer(
                    answerId: answerId,
                    reportType: reportType,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        reportBoard: { boardId, reportType in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await ReportAPI.reportBoard(
                    boardId: boardId,
                    reportType: reportType,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        reportBoardComment: { commentId, reportType in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await ReportAPI.reportBoardComment(
                    boardCommentId: commentId,
                    reportType: reportType,
                    server: server,
                    accessToken: accessToken
                )
            }
        }, reportAnswerComment: { commentId, reportType in
            // TODO: 추후 API 교체 필요
            UserDefaultsService.reportedAnswerCommentIds.append(commentId)
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var reportRepository: ReportRepository {
        get { self[ReportRepository.self] }
        set { self[ReportRepository.self] = newValue }
    }
}
