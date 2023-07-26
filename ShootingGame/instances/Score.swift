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
    var combo:Int = 1 {
        didSet {
            if oldValue != combo {
                comboChangeDate = Date()
            }
        }
    }
    
    var comboChangeDate:Date? = nil
    let comboLimit:TimeInterval = 20
    
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
        var path2 = Path()
        let bgRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        path2.addRect(bgRect)
        context.fill(path2, with: .color(.backGround3.opacity(0.8)))

        context.draw(Text("\(score)").font(.system(size: 30)), in: .init(x: 10, y: 10, width: 300, height: 30))
        
        let comboRect = CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width * 0.25, height: 20)
        var path = Path()
        path.addRect(comboRect)
        context.fill(path, with: .color(.blue))
        
        if let d = comboChangeDate {
            let distance = Date().timeIntervalSince1970 - d.timeIntervalSince1970
            if distance < comboLimit && combo > 1 {
                let p =  (comboLimit - distance) / comboLimit
                
                var path2 = Path()
                path2.addRect(.init(origin: comboRect.origin, size: .init(width: comboRect.width * p, height: comboRect.height)))
                context.fill(path2, with: .color(.yellow))
            }
            if  distance > comboLimit {
                combo = 1
            }
        }
        context.draw(Text("combo : \(combo)"), in: comboRect)
        
        
    }
    
}
