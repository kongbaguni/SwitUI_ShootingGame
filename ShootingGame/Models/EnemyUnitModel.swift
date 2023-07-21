//
//  EnemyUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class EnemyUnitModel : MovementUnitModel {
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        images[.보통] = [Image("star1")]
        images[.공격당함] = [Image("star3")]
        images[.파괴직전] = [Image("star2")]
        super.draw(context: context, screenSize: screenSize)
    }
    
    override var isScreenOut: Bool {
        rect.isScreenOut(screenSize: screenSize, ignore: .top)
    }
}
