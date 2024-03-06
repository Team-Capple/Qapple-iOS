//
//  DTO.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

/// 질문
struct NewQuestion: Identifiable & Codable {
    let id: Int // 키값
    let content: String // 질문 내용
    let questionStatus: String // 상태
    let answers: [NewAnswer] // 답변 리스트
    let livedAt: Date // 메인 질문 변경 시각
    let createdAt: Date // 생성 시각
    let updateAt: Date // 수정 시각
    let deletedAt: Date // 삭제 시각
}

/// 답변
struct NewAnswer: Identifiable & Codable {
    let id: Int // 키값
    let memberId: Int // 멤버 키
    let questionId: Int // 질문 키
    let content: Int // 답변 내용
    let tags: String // 태그
    let createdAt: Date // 생성 시각
    let modifiedAt: Date // 수정 시각
    let deletedAt: Date // 삭제 시각
}

/// 사용자
struct Member: Identifiable & Codable {
    let id: Int // 키값
    let nickname: String // 닉네임
    let email: String // 학생증 이메일
    let createdAt: Date // 생성 시각
    let modifiedAt: Date // 수정 시각
    let deletedAt: Date // 삭제 시각
    let profileImage: MemberProfileImage // 프로필 이미지
}

/// 사용자 프로필 이미지
struct MemberProfileImage: Identifiable & Codable {
    let id: Int // 키값
    let imageUrl: String // 접근 URL
    let inUse: Bool // 사용 상태
    let memberId: Int // 멤버 키
    let createdAt: Date // 생성 시각
    let modifiedAt: Date // 수정 시각
    let deletedAt: Date // 삭제 시각
}

struct Tag: Identifiable & Codable {
    let id: Int // 키값
    let content: String // 태그 이름
    let count: Int // 태극 사용된 횟수
    let answerId: Int // 답변 키
    let questionId: Int // 질문 키
}

/// 질문 좋아요
struct QuestionHeart: Identifiable & Codable {
    let id: Int // 키값
    let memberId: Int // 멤버 키
    let questionId: Int // 질문 키
}

/// 답변 좋아요
struct AnswerHeart: Identifiable & Codable {
    let id: Int // 키값
    let answerId: Int // 답변 키
    let memberId: Int // 멤버 키
}

enum QuestionStatus: String {
    case live = "LIVE" // 진행중
    case old = "OLD" // 종료
    case hold = "HOLD" // 대기?
    case pending = "PENDING" // 대기?
}
