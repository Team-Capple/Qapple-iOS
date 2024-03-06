//
//  BaseResponse.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import Foundation

struct BaseResponse<ResultType: Codable> {
    let timeStamp: String
    let code: String
    let message: String
    let result: ResultType
}
