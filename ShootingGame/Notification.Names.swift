//
//  Notification.Names.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
extension Notification.Name {
    static let dragPointerChanged = Notification.Name("dragPointerChanged_observer")
    static let dragEnded = Notification.Name("dragEnded_observer")
    static let makePlayerShot = Notification.Name("makePlayerShot_observer")
    static let makeEnemyShot = Notification.Name("makeEnemyShot_observer")
}
