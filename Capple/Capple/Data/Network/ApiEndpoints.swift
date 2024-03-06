//
//  ApiEnpoints.swift
//  Capple
//
//  Created by Kyungsoo Lee on 2/9/24.
//

import Foundation

enum ApiEndpoints {
    static let scheme = "http"
    static let host = "43.203.126.187"
    static let port = 8080
    
    enum Path: String {
        case questions = "/questions"
    }
}

extension ApiEndpoints {
    
    /// 기본 URL 주소 문자열을 반환합니다.
    static func basicURLString(path: ApiEndpoints.Path) -> URL? {
        let url = URL(string: "\(scheme)://\(host):\(port)\(path.rawValue)")
        return url
    }
}
