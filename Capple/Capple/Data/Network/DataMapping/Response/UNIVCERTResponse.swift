//
//  UNIVCERTResponse.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

struct UNIVCERTResponse {
    
    struct UserMailAuthentication: Codable {
        let success: Bool
    }
    
    struct CertifyCode: Codable {
        let success: Bool
        let univName: String
        let certified_email: String
        let certified_date: String
    }
}
