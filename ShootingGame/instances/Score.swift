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
    var gameOver = false
    var comboChangeDate:Date? = nil
    var missCount = 0
    let comboLimit:TimeInterval = 20
    var finalPoint:Int64? = nil
    
    init() {
        NotificationCenter.default.addObserver(forName: .unitDidDestoryed, object: nil, queue: nil) { [weak self] noti in
            guard let s = self else {
                return
            }
            if s.gameOver {
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
                self?.missCount += 1
            }
            
            if noti.object is PlayerUnitModel {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(3)) { [weak self] in
                    self?.gameOver = true
                    NotificationCenter.default.post(name: .gameOver, object: nil)
                }
            }
        }
        NotificationCenter.default.addObserver(forName: .gameClear, object: nil, queue: nil) { [weak self] noti in
            self?.gameOver = true
        }
        
    }
    
    func draw(context:GraphicsContext) {
        if gameOver {
            let w = UIScreen.main.bounds.width
            var p1 = Path()
            p1.addRect(UIScreen.main.bounds)
            context.fill(p1, with: .color(.backGround2.opacity(0.8)))
            
            context.draw(Text("Game Over").font(.system(size:40)).foregroundColor(.textColorStrong),
                         in: .init(x: 10, y: 10, width: w, height: 100))
            
            context.draw(Text("Score : \(score)").font(.system(size:20)).foregroundColor(.textColorNormal),
                         in: .init(x: 10, y: 70, width: w, height: 40))
            finalPoint = score
            if missCount == 0 {
                let bonus = score / 2
                context.draw(Text("No Miss Bonnus : \(bonus)"),
                             in: .init(x: 10, y: 100, width: w, height: 40))
                context.draw(Text("Total Score : \(score + bonus)"),
                             in: .init(x: 10, y: 140, width: w, height: 40))
                finalPoint = score + bonus
            }
            //TODO : GameCenter 포인트 보고하기
        } else {
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
    
}
