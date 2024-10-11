//
//  PushNotificationManager.swift
//  Qapple
//
//  Created by 문인범 on 10/11/24.
//

import Foundation


final class PushNotificationManager: ObservableObject {
    static let shared = PushNotificationManager()
    @Published var boardId: Int?
    @Published var questionId: Int?
    
    private init() {}
}
