//
//  StageManager.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import Foundation
import SwiftUI

fileprivate let p1 = CGPoint(x: UIScreen.main.bounds.width * 0.125, y: -50)
fileprivate let p2 = CGPoint(x: UIScreen.main.bounds.width * 0.25, y: -50)
fileprivate let p3 = CGPoint(x: UIScreen.main.bounds.width * 0.375, y: -50)
fileprivate let p4 = CGPoint(x: UIScreen.main.bounds.width * 0.625, y: -50)
fileprivate let p5 = CGPoint(x: UIScreen.main.bounds.width * 0.75, y: -50)
fileprivate let p6 = CGPoint(x: UIScreen.main.bounds.width * 0.875, y: -50)

func makeEnemyData(num:Int,pos:CGPoint)->EnemyData {
    switch num {
    case 0:
        return .init(center: pos,
                     range: 30,
                     movement: .init(dx: 0, dy: 1),
                     speed: 1,
                     shotTypes: [.삼번샷],
                     hp: 40,
                     atteck: 2,
                     dropItems: [.point])
    case 1:
        return .init(center: pos,
                     range: 40,
                     movement: .init(dx: 0, dy: 1),
                     speed: 1,
                     shotTypes: [.조준샷,.조준샷,.조준샷,.일번샷],
                     hp: 100,
                     atteck:2,
                     dropItems: [.point]
        )
        
    case 2:
        return .init(center: pos,
                  range: 50,
                  movement: .init(dx: 0, dy: 1),
                  speed: 1,
                  shotTypes: [.일번샷, .이번샷, .조준샷],
                  hp: 150,
                  atteck: 2,
                  dropItems: [.point]
            )
    case 3:
        return .init(center: pos,
                  range: 60,
                  movement: .init(dx: 0, dy: 1),
                  speed: 1,
                  shotTypes: [.조준샷,.조준샷,.조준샷,.일번샷],
                  hp: 100,
                  atteck:2,
                  dropItems: [.powerup]
                 )
        
    case 4:
        return .init(center: pos,
                  range: 200,
                  movement: .init(dx: 0, dy: 1),
                  speed: 0.5,
                  shotTypes: [.일번샷, .이번샷],
                  hp: 500,
                  atteck:3,
                  dropItems: [.hp, .point, .point]
                 )
    default:
        return .init(center: pos,
                     range: 30,
                     movement: .init(dx: 0.1, dy: 1),
                     speed: 1,
                     shotTypes: [.일번샷],
                     hp: 10,
                     atteck: 1,
                     dropItems: [.point])
        
    }
}

class StageManager {
    var data:StageModel? = nil
    
    func makeStage(stageNumber:Int, level:Int) {
        switch stageNumber {
        case 1:
            data = StageModel(level:level, enemys: [
                50 : [
                    makeEnemyData(num: 0, pos: p1),
                    makeEnemyData(num: 0, pos: p2),
                    makeEnemyData(num: 1, pos: p3),
                    makeEnemyData(num: 1, pos: p4),
                    makeEnemyData(num: 0, pos: p5),
                    makeEnemyData(num: 0, pos: p6)
                ],
                100 : [
                    makeEnemyData(num: 0, pos: p1),
                    makeEnemyData(num: 0, pos: p6)
                ],
                150 : [
                    makeEnemyData(num: 0, pos: p1),
                    makeEnemyData(num: 0, pos: p6)
                ],

                200 : [
                    makeEnemyData(num: 2, pos: p3)
                ],
                
                250 : [
                    makeEnemyData(num: 3, pos: p4)
                ],
                
                400 : [                   
                   makeEnemyData(num: 4, pos: p2),
                   makeEnemyData(num: 4, pos: p4)
                ],
                
            ])
            
        default:
            break
        }
    }
    var isTimeUp = false
    func process(count:UInt64) {
        if isTimeUp {
            return
        }
        guard let data = data else {
            return
        }
        
        data.process(count: count)
        
        let arr = [UInt64](data.enemys.keys)
        let value = arr.sorted().last!
        if value < count {
            NotificationCenter.default.post(name: .stageTimeUp, object: nil)
            self.data = nil
            isTimeUp = true 
        }
        
    }
}
