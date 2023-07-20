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
    
    func isScreenOut(screenSize:CGSize, iGnore:IgnoreDirection? = nil)->Bool {
        if origin.x + size.width < 0 && iGnore != .left {
            return true
        }
        if origin.y + size.height < 0 && iGnore != .top {
            return true
        }
        if origin.x > screenSize.width && iGnore != .right {
            return true
        }
        if origin.y > screenSize.height && iGnore != .bottom {
            return true
        }
        return false
    }
}
