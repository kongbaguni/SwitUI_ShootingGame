//
//  CGPoint+Extensions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
extension CGPoint {
    static func + (left:CGPoint, right:CGPoint) -> CGPoint {
        return .init(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left:CGPoint, right:CGPoint) -> CGPoint {
        return .init(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func + (left:CGPoint, right:CGVector) -> CGPoint {
        return .init(x: left.x + right.dx, y: left.y + right.dy)
    }
    
    static func - (left:CGPoint, right:CGVector) -> CGPoint {
        return .init(x: left.x - right.dx, y: left.y - right.dy)
    }
    
    static func += (lhs: inout CGPoint, rhs: CGVector) {
            lhs.x += rhs.dx
            lhs.y += rhs.dy
    }
    
    func vector(to point: CGPoint) -> CGVector {
        return CGVector(dx: point.x - self.x, dy: point.y - self.y)
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return sqrt(dx * dx + dy * dy)
    }
}
