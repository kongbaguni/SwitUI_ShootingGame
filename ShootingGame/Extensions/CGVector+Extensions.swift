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
}
