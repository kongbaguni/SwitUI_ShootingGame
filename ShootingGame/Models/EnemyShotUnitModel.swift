//
//  EnemyShotUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/24.
//

import Foundation
import SwiftUI

class EnemyShotUnitModel : MovementUnitModel {
    enum ShotType {
        case 일반
        case 추적레이저빔
    }

    let shotType:ShotType
    init(center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat, type: ShotType) {
        shotType = type
        super.init(center: center, range: range, movement: movement, speed: speed)
        switch type {
        case .일반:
            imageNames[.보통] = ["shot1","shot2"]
            imageNames[.공격당함] = ["shot3"]
            imageNames[.파괴직전] = ["shot3"]
            imageNames[.힐링] = ["shot1"]
        case .추적레이저빔:
            imageNames[.보통] = ["laser1"]
            imageNames[.공격당함] = ["laser1"]
            imageNames[.파괴직전] = ["laser1"]
            imageNames[.힐링] = ["laser1"]
            break
        }
        hp = 1
        atteck = 1
        NotificationCenter.default.addObserver(forName: .gameClear, object: nil, queue: nil) { [weak self] noti in
            self?.addDamage(value: 100)
        }

    }
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        self.screenSize = screenSize
        process()
        
        switch shotType {
        case .일반:
            var path = Path()
            path.addArc(center: center, radius: range, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
            context.fill(path, with: .color(.orange))
            break
        case .추적레이저빔:
            var path = Path()
            path.move(to: center)
            let a = center
            let b = center + movement
            let c = b + movement.rotated(by: 90) * 10
            let d = b + movement.rotated(by: -90) * 10
            
            path.addLines([a,b,c,a,b,d,a])
            context.fill(path, with: .color(.red))
        }
    }

}

