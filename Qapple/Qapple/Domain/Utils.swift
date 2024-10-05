//
//  Utils.swift
//  Qapple
//
//  Created by 김민준 on 10/5/24.
//

import Foundation

public class Utils {
    internal static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    internal static func getBuildVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}
