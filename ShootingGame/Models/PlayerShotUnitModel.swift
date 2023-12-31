//
//  PlayerShotModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/21.
//

import SwiftUI

class PlayerShotUnitModel : MovementUnitModel {
    enum ShotType {
        case 콩알탄
        case 레이저
    }
    let shotType:ShotType
    weak var before:PlayerShotUnitModel? = nil
    weak var next:PlayerShotUnitModel? = nil
        
    func getPoints(_ type:ShotType)->[CGPoint] {
        switch type {
        case .레이저:
            return [
                rect.origin,
                .init(x: rect.origin.x + rect.width, y: rect.origin.y),
                next?.getPoints(type)[0] ?? .init(x: rect.origin.x, y: rect.origin.y + rect.height),
                next?.getPoints(type)[1] ?? .init(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height),
            ]
        case .콩알탄:
            let direction:CGVector = movement
//            if let before = before {
//                if before.center != center {
//                    direction = center.directionVector(to: before.center, withSpeed: 10)
//                }
//            }
            return [
                center + direction * 2,
                center - direction.rotated(by: 90),
                center - direction.rotated(by: -90)
            ]
                        
        }
    }
    
    
    
    init(type:ShotType, center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat, atteck:Int) {
        shotType = type
        super.init(center: center, range: range, movement: movement, speed: speed)
        imageNames[.보통] = ["laser1"]
        imageNames[.공격당함] = ["laser1"]
        hp = 1
        self.atteck = atteck
    }
    
    override var rect: CGRect {
        .init(x: center.x - 10, y: center.y - 28, width: 20, height: 28 * 2)
    }
    
    override func isCrash(unit: UnitModel) -> Bool {
        return rect.intersects(unit.rect)
    }
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        self.screenSize = screenSize
        process()
        let points = getPoints(shotType)
        switch shotType {
        case .레이저:
            let color:[Color] = [.yellow, .orange, .red, .green, .blue]
            if next == nil {
                var path2 = Path()
                path2.addArc(center: .init(x: center.x, y: center.y + range), radius: range * 2, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                context.fill(path2, with: .color(color[atteck-1]))
            }
            
            switch status {
            case .공격당함:
                var path2 = Path()
                path2.addArc(center: center, radius: 30, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                context.fill(path2, with: .color(color[atteck-1]))
                var path1 = Path()
                path1.addArc(center: center, radius: 25, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                context.fill(path1, with: .color(.blue))

            default:
                var path1 = Path()
                path1.move(to: points[0])
                path1.addLines([points[1], points[3], points[2],points[0]])
                context.fill(path1, with: .color(color[atteck-1]))
            }
        case .콩알탄:
            var path = Path()
            path.move(to: points.last!)
            path.addLines(points)
            context.fill(path, with: .color(.white))
        }
       
    }
}
