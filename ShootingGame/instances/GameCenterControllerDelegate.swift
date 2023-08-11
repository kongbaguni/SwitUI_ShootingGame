//
//  GameCenterControllerDelegate.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/08/08.
//

import Foundation
import SwiftUI
import GameKit

class GameCenterControllerDelegate : NSObject, GKGameCenterControllerDelegate {
    weak var leaderboardController : UIViewController? = nil
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        leaderboardController?.dismiss(animated: true)
    }
}
