//
//  CGRect+Extnesions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
extension CGRect {
    enum IgnoreDirection {
        case top
        case bottom
        case left
        case right
    }
    
    func isScreenOut(screenSize:CGSize, ignore:IgnoreDirection? = nil, padding:CGFloat = 0 )->Bool {
        if origin.x + size.width + padding < 0 && ignore != .left {
            return true
        }
        if origin.y + size.height + padding < 0 && ignore != .top {
            return true
        }
        if origin.x > screenSize.width + padding && ignore != .right {
            return true
        }
        if origin.y > screenSize.height + padding && ignore != .bottom {
            return true
        }
        return false
    }
    
    static func + (left:CGRect, right:CGFloat) -> CGRect {
        return .init(x: left.origin.x - right / 2, y: left.origin.y - right / 2, width: left.size.width + right, height: left.size.height + right)
    }
    
    static func - (left:CGRect, right:CGFloat) -> CGRect {
        return left + -1 * right
    }
    
    static func + (left:CGRect, right:Int) -> CGRect {
        return left + CGFloat(right)
    }
    
    static func - (left:CGRect, right:Int) -> CGRect {
        return left - CGFloat(right)
    }
    
}
