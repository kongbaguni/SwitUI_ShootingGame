//
//  CGRect+Extnesions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
extension CGRect {
    func isScreenOut(screenSize:CGSize)->Bool {
        if origin.x + size.width < 0 {
            return true
        }
        if origin.y + size.height < 0 {
            return true
        }
        if origin.x > screenSize.width {
            return true
        }
        if origin.y > screenSize.height {
            return true
        }
        return false
    }
}
