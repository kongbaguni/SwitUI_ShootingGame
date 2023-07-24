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
        images[.보통] = [Image("shot1")]
        images[.공격당함] = [Image("shot3")]
        hp = 1
        atteck = 1
    }
    
}
