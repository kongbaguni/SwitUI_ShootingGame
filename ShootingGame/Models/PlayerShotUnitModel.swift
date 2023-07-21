//
//  PlayerShotModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/21.
//

import SwiftUI

class PlayerShotUnitModel : MovementUnitModel {
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        images[.보통] = [Image("shot1")]
        images[.공격당함] = [Image("shot3")]
        super.draw(context: context, screenSize: screenSize)
    }    
}
