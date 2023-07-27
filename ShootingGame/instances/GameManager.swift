//
//  GameManager.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class GameManager {
    func clear() {
        playerShotsArr.removeAll()
        playerShots.removeAll()
        enemys.removeAll()
        enemyShots.removeAll()
    }
    
    var isTestMode = true
    var level = 1
    
    var gameOverCheck = false
    
    var stage = 1 {
        didSet {
            if isTestMode == false {
                timeline = 0
                stageManager.makeStage(stageNumber: stage, level: level)
            }
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .makePlayerShot, object: nil, queue: nil) { [weak self] noti in
            guard let s = self else {
                return
            }
                    
            if let arr = noti.object as? [PlayerShotUnitModel] {
                s.insertPlayerShot(arr: arr)
            }
            else if let obj = noti.object as? PlayerShotUnitModel {
                s.insertPlayerShot(arr: [obj])
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
        NotificationCenter.default.addObserver(forName: .makeEnemy, object: nil, queue: nil) { [weak self] noti in
            if let obj = noti.object as? EnemyUnitModel {
                self?.enemys.append(obj)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .stageTimeUp, object: nil, queue: nil) { [weak self] noti in
            if self?.isTestMode == false {
                self?.gameOverCheck = true
            }
        }
        
        NotificationCenter.default.addObserver(forName: .unitDidDestoryed, object: nil, queue: nil) { [weak self] noti in
            if let enemy = noti.object as? EnemyUnitModel {
                for type in enemy.dropItem {
                    let item = ItemUnitModel(
                        itemType: type,
                        center: enemy.center + .init(x: .random(in: -50...50), y: .random(in: -50...50)),
                        range: enemy.range / 2,
                        movement: .init(dx: 0, dy: 2),
                        speed: 2)
                    if let p = self?.player {
                        item.setTarget(unit: p)
                    }
                    self?.items.append(item)
                }
            }
        }
    }
    
    let particle:Particle = .init()
    let score:Score = .init()
    let stageManager:StageManager = .init()
    var enemys:[EnemyUnitModel] = []
    var enemyShots:[EnemyShotUnitModel] = []
    var items:[ItemUnitModel] = []
    
    private var playerShots:[[PlayerShotUnitModel]] = []
    private var playerShotsArr:[PlayerShotUnitModel] = []
    
    func insertPlayerShot(arr:[PlayerShotUnitModel]) {
        while playerShots.count < arr.count {
            playerShots.append([])
        }
        for (idx, item) in arr.enumerated() {
            playerShots[idx].last?.next = item
            item.before = playerShots[idx].last
            
            playerShots[idx].append(item)
            playerShotsArr.append(item)
        }
        
    }
    func removePlayerShot(item:PlayerShotUnitModel) {
        for (i,arr) in playerShots.enumerated() {
            if let j = arr.firstIndex(of: item) {
                playerShots[i].remove(at: j)
            }
        }
        if let idx = playerShotsArr.firstIndex(of: item) {
            playerShotsArr.remove(at: idx)
        }
    }
    
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
                                  shotTypes: types.randomElement()!,
                                  dropItem: [.point,.point]
        )
        enemys.append(unit)
        print(enemys.count)
    }
    
    func dropItem() {
        let type:ItemUnitModel.ItemType = .allCases.randomElement()!
        
        let item:ItemUnitModel = .init(
            itemType: type,
            center: .init(x: .random(in: 50...UIScreen.main.bounds.width - 50), y: 0),
            range: 30,
            movement: .init(dx: 0, dy: 1), speed: 5)
        item.setTarget(unit: player)
        items.append(item)
    }
    
    var timeline:UInt64 = 0
    func draw(context:GraphicsContext, screenSize:CGSize) {
        timeline += 1
        if isTestMode == false {
            if stageManager.data == nil {
                stageManager.makeStage(stageNumber: stage, level: level)
            }
            stageManager.process(count: timeline)
        }
        self.screenSize = screenSize
                    
        _ = items.map({ item in
            item.draw(context: context, screenSize: screenSize)
            if item.isCrash(unit: player) {
                switch item.itemType {
                case .hp:
                    player.healing(value: item.atteck)
                case .point:
                    break
                case .powerup:
                    player.powerUp(value: item.atteck)
                }
                if let idx = items.firstIndex(of: item) {
                    items.remove(at: idx)
                }
                NotificationCenter.default.post(name: .itemGet, object: item)
            }
            if item.isScreenOut {
                if let idx = items.firstIndex(of: item) {
                    items.remove(at: idx)
                }
            }
        })
        player.draw(context: context, screenSize: screenSize)
        let array:[[NSObject]] = [enemys, enemyShots, playerShotsArr]
        _ = array.map { arr in
            _ = arr.map { unit in
                if (unit as? UnitModel)?.isDie == true {
                    NotificationCenter.default.post(name: .unitDidDestoryed, object: unit)
                }
            }
        }
        
        _ = enemys.map { unit in
            unit.draw(context: context,screenSize: screenSize)
            if unit.isScreenOut || unit.isDie {
                if let idx = enemys.firstIndex(of: unit) {
                    enemys.remove(at: idx)
                }
            }
        }
        _ = playerShotsArr.reversed().map { unit in
            unit.draw(context: context,screenSize: screenSize)
            if unit.isScreenOut || unit.isDie {
                removePlayerShot(item: unit)
            }
            
            for enemy in enemys {
                if unit.isCrash(unit: enemy) {
                    unit.addDamage(value: 100)
                    enemy.addDamage(value: 1)
                }
            }
        }
        _ = enemyShots.map { unit in
            unit.draw(context: context, screenSize: screenSize)

            let a = unit.isScreenOut
            let b = unit.isDie
            if a || b {
                if let idx = enemyShots.firstIndex(of: unit) {
                    enemyShots.remove(at: idx)
                }
            }
            
            if(unit.isCrash(unit: player) && player.isDie == false) {
                if isTestMode == false {
                    player.addDamage(value: unit.atteck)
                }
                unit.addDamage(value: player.atteck)
            }
            
        }
        particle.draw(context: context)
        score.draw(context: context)
        
        if isTestMode {
            let str = """
        unitCount : \(enemys.count)
        playerShotCount : \(playerShots.count)
        enemyShotCount : \(enemyShots.count)
        missCount : \(score.missCount)
        """
            context.draw(Text(str).font(.system(size: 8)), in: .init(x: UIScreen.main.bounds.width / 2 + 20, y: 10, width: 200, height: 100))
        }

        if gameOverCheck {
            if enemys.count == 0 && items.count == 0 {
                NotificationCenter.default.post(name: .gameClear, object: nil)
                gameOverCheck = false            
            }
        }
    }
    
}
