//
//  ItemUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/27.
//

import Foundation
class ItemUnitModel : TargettingMovementUnitModel {
    enum ItemType : CaseIterable {
        case powerup
        case hp
        case point
    }
    
    let itemType:ItemType
    init(itemType:ItemType,center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat) {
        self.itemType = itemType
        super.init(center: center, range: range, movement: movement, speed: speed)

        switch itemType {
        case .hp:
            imageNames[.보통] = ["hpup"]
            atteck = 50
            setTargettingRange(range: 300)
        case .point:
            imageNames[.보통] = ["point"]
            atteck = 500
            setTargettingRange(range: 100)
        case .powerup:
            imageNames[.보통] = ["powerup"]
            atteck = 1
            setTargettingRange(range: 300)
        }
    }
    
    
}
