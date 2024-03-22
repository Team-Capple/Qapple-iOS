//
//  UNIVCERTRequest.swift
//  Capple
//
//  Created by 김민준 on 3/14/24.
//

import Foundation

class UNIVCERTRequest {
    
    struct UserMailAuthentication: Codable {
        let key: String
        let email: String
        var univName: String = "POSTECH"
        var univ_check: Bool = false
    }
    
    struct CertifyCode: Codable {
        let key: String
        let email: String
        var univName: String = "POSTECH"
        let code: Int
    }
    
    struct ClearEmail: Codable {
        let key: String
    }
}
