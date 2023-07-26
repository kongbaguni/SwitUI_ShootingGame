//
//  StageModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import Foundation
struct EnemyData {
    let center:CGPoint
    let range:CGFloat
    let movement:CGVector
    let speed:CGFloat
    let shotTypes:[EnemyUnitModel.EnemyShotType]
    let hp:Int
    let atteck:Int
}


class StageModel {
    let level:Int
    let enemys:[UInt64:[EnemyData]]
 
    init(level: Int, enemys: [UInt64 : [EnemyData]]) {
        self.level = level
        self.enemys = enemys
    }
    
    public func process(count:UInt64) {
        if let arr = enemys[count] {
            _ = arr.map { data in
                let enemy = EnemyUnitModel(
                    center: data.center,
                    range: data.range,
                    movement: data.movement,
                    speed: data.speed,
                    shotTypes: data.shotTypes)
                enemy.atteck = data.atteck * level
                enemy.hp = data.hp * level
                NotificationCenter.default.post(name: .makeEnemy, object: enemy)
            }            
        }
    }
    
}


