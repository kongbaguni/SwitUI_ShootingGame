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
            if let arr = noti.object as? [PlayerShotUnitModel] {
                for item in arr {
                    self?.playerShots.append(item)
                }
            }
            else if let obj = noti.object as? PlayerShotUnitModel {
                self?.playerShots.append(obj)
            }
        }
        NotificationCenter.default.addObserver(forName: .makeEnemyShot, object: nil, queue: nil) { [weak self] noti in
            if let arr = noti.object as? [EnemyShotUnitModel] {
                for item in arr {
                    self?.enemyShots.append(item)
                }
            }
            else if let obj = noti.object as? EnemyShotUnitModel {
                self?.enemyShots.append(obj)
            }
        }
    }
    let particle:Particle = .init()
    let score:Score = .init()
    
    var enemys:[EnemyUnitModel] = []
    var enemyShots:[EnemyShotUnitModel] = []
    var playerShots:[PlayerShotUnitModel] = []
    var screenSize:CGSize = .zero
    var player = PlayerUnitModel(center: .init(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2), range: 50)
    func addUnit() {
        let c = CGPoint(x: .random(in: 50...UIScreen.main.bounds.width - 50), y: -100)
        let types:[[EnemyUnitModel.EnemyShotType]] = [
            [.조준샷, .조준샷, .조준샷, .이번샷],
            [.이번샷, .일번샷, .일번샷, .조준샷],
            [.이번샷, .이번샷, .일번샷],
            [.일번샷]
        ]
        
        let unit = EnemyUnitModel(center: c,
                                  range: .random(in: 50...70),
                                  movement: .init(dx: 0, dy: .random(in: 1...2)),
                                  speed: .random(in: 0.1...1),
                                  shotTypes: types.randomElement()!                                  
        )
        enemys.append(unit)
        print(enemys.count)
    }
    
    func draw(context:GraphicsContext, screenSize:CGSize) {
        self.screenSize = screenSize
        #if DEBUG
        let str = """
        unitCount : \(enemys.count)
        playerShotCount : \(playerShots.count)
        enemyShotCount : \(enemyShots.count)
        """
        context.draw(Text(str), in: .init(x: 30, y: 30, width: 200, height: 100))
        #endif 
                    
        
        player.draw(context: context, screenSize: screenSize)
        let array:[[NSObject]] = [enemys, enemyShots, playerShots]
        for arr in array {
            for unit in arr {
                if (unit as? UnitModel)?.isDie == true {
                    NotificationCenter.default.post(name: .unitDidDestoryed, object: unit)
                }
            }
        }
        
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
        
        for unit in enemyShots {
            unit.draw(context: context, screenSize: screenSize)

            let a = unit.isScreenOut
            let b = unit.isDie
            if a || b {
                if let idx = enemyShots.firstIndex(of: unit) {
                    enemyShots.remove(at: idx)
                }
            }
            
            if(unit.isCrash(unit: player)) {
                player.addDamage(value: unit.atteck)
                unit.addDamage(value: player.atteck)
            }
            
        }
        particle.draw(context: context)
        score.draw(context: context)
    }
    
}
