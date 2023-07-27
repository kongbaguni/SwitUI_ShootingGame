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


class StageManager {
    var data:StageModel? = nil
    
    func makeStage(stageNumber:Int, level:Int) {
        switch stageNumber {
        case 1:
            data = StageModel(level:level, enemys: [
                50 : [
                    .init(center: p2,
                          range: 50,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.일번샷],
                          hp: 50,
                          atteck: 1,
                          dropItems: [.point]
                         ),
                ],
                
                100 : [
                    .init(center: p1,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.조준샷,.조준샷,.조준샷,.일번샷],
                          hp: 100,
                          atteck:2,
                          dropItems: [.point]
                         ),
                    .init(center: p3,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.일번샷, .이번샷, .조준샷],
                          hp: 100,
                          atteck: 2,
                          dropItems: [.point]
                         ),
                ],
                
                200 : [
                    .init(center: p1,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.조준샷,.조준샷,.조준샷,.일번샷],
                          hp: 100,
                          atteck:2,
                          dropItems: [.powerup]
                         ),
                    .init(center: p3,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.일번샷, .이번샷, .조준샷],
                          hp: 100,
                          atteck: 2,
                          dropItems: [.point]
                         ),
                ],
                
                400 : [
                    .init(center: p2,
                          range: 100,
                          movement: .init(dx: 0, dy: 1),
                          speed: 0.5,
                          shotTypes: [.일번샷, .이번샷],
                          hp: 500,
                          atteck:3,
                          dropItems: [.hp, .point, .point]
                         ),
                    .init(center: p5,
                          range: 100,
                          movement: .init(dx: 0, dy: 1),
                          speed: 0.5,
                          shotTypes: [.일번샷, .이번샷, .조준샷],
                          hp: 500,
                          atteck: 3,
                          dropItems: [.point, .point, .point]
                         ),
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
