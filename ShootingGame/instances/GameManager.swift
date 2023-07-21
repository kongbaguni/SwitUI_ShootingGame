//
//  GameManager.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class GameManager {
    init() {
        NotificationCenter.default.addObserver(forName: .makePlayerShot, object: nil, queue: nil) { [weak self] noti in
            if let obj = noti.object as? PlayerShotUnitModel {
                self?.playerShots.append(obj)
            }
        }
    }
    var enemys:[EnemyUnitModel] = []
    var playerShots:[PlayerShotUnitModel] = []
    var screenSize:CGSize = .zero
    var player = PlayerUnitModel(center: .init(x: 100, y: 100), range: 50)
    func addUnit() {
        let c = CGPoint(x: .random(in: 50...350), y: -100)
        let unit = EnemyUnitModel(center: c, range: .random(in: 50...70), movement: .init(dx: 0, dy: .random(in: 1...2)), speed: .random(in: 0.1...1))
        enemys.append(unit)
        print(enemys.count)
    }
    
    func draw(context:GraphicsContext, screenSize:CGSize) {
        self.screenSize = screenSize
        context.draw(Text("unitCount: \(enemys.count)\nplayerShotCount: \(playerShots.count)"), in: .init(x: 30, y: 30, width: 200, height: 100))
            
        for unit in enemys {
            unit.draw(context: context,screenSize: screenSize)
            if unit.isScreenOut || unit.isDie {
                if let idx = enemys.firstIndex(of: unit) {
                    enemys.remove(at: idx)
                }
            }
        }
        for unit in playerShots {
            unit.draw(context: context,screenSize: screenSize)
            if unit.isScreenOut || unit.isDie {
                if let idx = playerShots.firstIndex(of: unit) {
                    playerShots.remove(at: idx)
                }
            }
            
            for enemy in enemys {
                if unit.isCrash(unit: enemy) {
                    unit.addDamage(value: 100)
                    enemy.addDamage(value: 1)
                }
            }
        }
        
        player.draw(context: context, screenSize: screenSize)
        
    }
    
}
