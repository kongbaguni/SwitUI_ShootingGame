//
//  CGVector+Extensions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
extension CGVector {
    static func * (left:CGVector, right:CGFloat) -> CGVector {
        return .init(dx: left.dx * right, dy: left.dy * right)
    }
    
    func rotated(by angleInRadians: CGFloat) -> CGVector {
        let cosAngle = cos(angleInRadians)
        let sinAngle = sin(angleInRadians)
        
        let rotatedX = self.dx * cosAngle - self.dy * sinAngle
        let rotatedY = self.dx * sinAngle + self.dy * cosAngle
        
        return CGVector(dx: rotatedX, dy: rotatedY)
    }
    
    var angleInRadians: CGFloat {
        return atan2(dy, dx)
    }
    
    var angleInDegrees: CGFloat {
        return angleInRadians * 180.0 / CGFloat.pi
    }
}
