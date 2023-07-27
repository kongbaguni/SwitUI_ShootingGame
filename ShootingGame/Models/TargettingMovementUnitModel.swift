//
//  TargettingMovementUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/27.
//

import Foundation
class TargettingMovementUnitModel : MovementUnitModel {
    private var targetUnit:UnitModel? = nil
        
    public func setTarget(unit:UnitModel) {
        targetUnit = unit
    }
    
    private var targettingRange:CGFloat? = nil
    
    public func setTargettingRange(range:CGFloat?) {
        targettingRange = range
    }
    
    override func process() {
        if let unit = targetUnit {
            let a = targettingRange == nil
            let b = targettingRange != nil ? center.distance(to: unit.center) < targettingRange! : false
            if a || b {
                movement = center.directionVector(to: unit.center, withSpeed: speed * 0.5)
            }
        }
        super.process()
    }
    
}
