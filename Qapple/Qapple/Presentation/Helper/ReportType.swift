//
//  ReportType.swift
//  Qapple
//
//  Created by 김민준 on 4/12/24.
//

import Foundation

enum ReportType: String, CaseIterable {
    
    /// 불법촬영물 등의 유통
    case DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS = "DISTRIBUTION_OF_ILLEGAL_PHOTOGRAPHS"
    
    /// 상업적 광고 및 판매
    case COMMERCIAL_ADVERTISING_AND_SALES = "COMMERCIAL_ADVERTISING_AND_SALES"
    
    /// 게시판 성격에 부적절함
    case INADEQUATE_BOARD_CHARACTER = "INADEQUATE_BOARD_CHARACTER"
    
    /// 욕설/비하
    case ABUSIVE_LANGUAGE_AND_DISPARAGEMENT = "ABUSIVE_LANGUAGE_AND_DISPARAGEMENT"
    
    /// 정당/정치인 비하 및 선거운동
    case POLITICAL_PARTY_OR_POLITICIAN_DEMEANING_AND_CAMPAIGNING = "POLITICAL_PARTY_OR_POLITICIAN_DEMEANING_AND_CAMPAIGNING"
    
    /// 욕설/사칭/사기
    case LEAK_IMPERSONATION_FRAUD = "LEAK_IMPERSONATION_FRAUD"
    
    /// 낚시/놀림/도배
    case TRICK_TEASING_PLASTERED = "TRICK_TEASING_PLASTERED"
}
