//
//  UserDefaults+Extensions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/28.
//

import Foundation
extension UserDefaults {
    var lastGoogleAdWatchTime:Date? {
        set {
            set(newValue?.timeIntervalSince1970, forKey: "lastGoogleAdWatchTime")
        }
        get {
            let value = double(forKey: "lastGoogleAdWatchTime")
            if value > 0 {
                return Date(timeIntervalSince1970: value)
            }
            return nil
        }
    }
}
