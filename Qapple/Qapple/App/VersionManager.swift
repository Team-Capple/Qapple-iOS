//
//  VersionManager.swift
//  Qapple
//
//  Created by 김민준 on 10/5/24.
//

import UIKit

struct VersionManager {
    
    enum VersionError: Error {
        case networkError
    }
    
    private static let appleId = "6480340462"
    
    private static var appStoreOpenUrlString: String {
        "itms-apps://itunes.apple.com/app/apple-store/\(appleId)"
    }
    
    /// 현재 버전이 최신 버전인지 확인
    static func isRecentVersion() async -> Result<Bool, Error> {
        guard let recentVersion = await appStoreAppVersion() else {
            return .failure(VersionError.networkError)
        }
        
        return .success(recentVersion == deviceAppVersion)
    }
    
    /// 앱스토어 내 최신 버전
    static func appStoreAppVersion() async -> String? {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(VersionManager.appleId)") else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                return nil
            }
            
            return appStoreVersion
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 현재 디바이스에 설치된 버전
    static var deviceAppVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    /// 빌드 버전
    static var buildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    /// 앱스토어를 Open합니다.
    static func openAppStore() {
        guard let url = URL(string: appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
