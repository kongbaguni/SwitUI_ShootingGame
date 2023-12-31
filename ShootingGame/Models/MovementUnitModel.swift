//
//  MovementUnit.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
class MovementUnitModel : UnitModel {
    var movement:CGVector
    var speed:CGFloat
    var isMovingPause:Bool = false
    
    init(center: CGPoint, range: CGFloat, movement:CGVector, speed:CGFloat) {
        self.movement = movement
        self.speed = speed
        super.init(center: center, range: range)
    }

    override func process() {
        super.process()
        if isMovingPause == false {
            center += (movement * speed)
        }
    }
}
