//
//  LeaderBoardController.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/08/10.
//

import SwiftUI
import GameKit

struct GameCenterViewController: UIViewControllerRepresentable {
    let state:GKGameCenterViewControllerState
    let delegate = GameCenterControllerDelegate()

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = GKGameCenterViewController(state: state)
        vc.gameCenterDelegate = delegate
        delegate.vc = vc
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
    
    class GameCenterControllerDelegate : NSObject, GKGameCenterControllerDelegate {
        weak var vc:UIViewController? = nil
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            vc?.dismiss(animated: true)
        }
    }
}
