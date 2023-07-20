//
//  PlayerUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class PlayerUnitModel : UnitModel {
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        images[.보통] = [Image("enemy1")]
        super.draw(context: context, screenSize: screenSize)
    }
}
