//
//  VersionService.swift
//  Qapple
//
//  Created by 김민준 on 1/20/25.
//

import UIKit

struct VersionService {
    private init() {}
    
    private static var appStoreOpenUrlString: String {
        "itms-apps://itunes.apple.com/app/apple-store/\(Constant.appleId)"
    }
    
    /// 현재 버전이 최신 버전인지 확인
    static func isRecentVersion() async throws -> Bool {
        guard let recentVersion = await appStoreAppVersion() else {
            throw VersionError.networkError
        }
        
        return recentVersion == deviceAppVersion
    }
    
    /// 앱스토어 내 최신 버전
    static func appStoreAppVersion() async -> String? {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(Constant.appleId)") else { return nil }
        
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
        guard let url = URL(string: appStoreOpenUrlString) else {
            print("URL 생성 실패: \(appStoreOpenUrlString)")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - VersionError

extension VersionService {
    
    enum VersionError: Error {
        case networkError
    }
}
