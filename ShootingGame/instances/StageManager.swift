//
//  StageManager.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import Foundation
import SwiftUI

fileprivate let p1 = CGPoint(x: UIScreen.main.bounds.width * 0.25, y: -50)
fileprivate let p2 = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: -50)
fileprivate let p3 = CGPoint(x: UIScreen.main.bounds.width * 0.75, y: -50)

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
                          atteck: 1
                         ),
                ],
                
                100 : [
                    .init(center: p1,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.조준샷,.조준샷,.조준샷,.일번샷],
                          hp: 100,
                          atteck:2                            
                         ),
                    .init(center: p3,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.일번샷, .이번샷, .조준샷],
                          hp: 100,
                          atteck: 2
                         ),
                ],
                
                200 : [
                    .init(center: p1,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.조준샷,.조준샷,.조준샷,.일번샷],
                          hp: 100,
                          atteck:2
                         ),
                    .init(center: p3,
                          range: 30,
                          movement: .init(dx: 0, dy: 1),
                          speed: 1,
                          shotTypes: [.일번샷, .이번샷, .조준샷],
                          hp: 100,
                          atteck: 2
                         ),
                ],
                
            ])
            
        default:
            break
        }
    }
    
    func process(count:UInt64) {
        data?.process(count: count)
    }
}
