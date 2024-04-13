//
//  IsMyAnswer.swift
//  Qapple
//
//  Created by 김민준 on 4/12/24.
//

import Foundation

struct IsMyAnswer: Identifiable {
    let id = UUID()
    let answerId: Int
    let isMine: Bool
}
