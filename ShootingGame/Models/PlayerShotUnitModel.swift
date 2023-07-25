//
//  PlayerShotModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/21.
//

import SwiftUI

class PlayerShotUnitModel : MovementUnitModel {
    override init(center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat) {
        super.init(center: center, range: range, movement: movement, speed: speed)
        imageNames[.보통] = ["laser1"]
        imageNames[.공격당함] = ["laser1"]
        hp = 1
        atteck = 1 
    }
    
    override var rect: CGRect {
        .init(x: center.x - 10, y: center.y - 28, width: 20, height: 28 * 2)
    }
    
    override func isCrash(unit: UnitModel) -> Bool {
        return rect.intersects(unit.rect)
    }
}
