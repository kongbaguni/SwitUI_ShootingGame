//
//  Score.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/25.
//

import Foundation
import SwiftUI

class Score {
    var score:Int64 = 0
    var combo:Int = 1
    
    init() {
        NotificationCenter.default.addObserver(forName: .unitDidDestoryed, object: nil, queue: nil) { [weak self] noti in
            guard let s = self else {
                return
            }
                    
            if noti.object is PlayerShotUnitModel {
                self?.score += 1 * Int64(s.combo)
            }
            if noti.object is EnemyUnitModel {
                self?.combo += 1
                self?.score += 100 * Int64(s.combo)
            }
            if noti.object is EnemyShotUnitModel {
                self?.combo = 1
            }
        }
    }
    
    func draw(context:GraphicsContext) {
        context.draw(Text("\(score) combo : \(combo)"), in: .init(x: 10, y: 10, width: 300, height: 30))
    }
    
}
