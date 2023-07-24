//
//  EnemyShotUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/24.
//

import Foundation
import SwiftUI

class EnemyShotUnitModel : MovementUnitModel {
    override init(center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat) {
        super.init(center: center, range: range, movement: movement, speed: speed)
        images[.보통] = [Image("shot1"),Image("shot2")]
        images[.공격당함] = [Image("shot3")]
        images[.파괴직전] = [Image("shot3")]
        images[.힐링] = [Image("shot1")]
        hp = 1
        atteck = 1        
    }

}
