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
    
    
}
