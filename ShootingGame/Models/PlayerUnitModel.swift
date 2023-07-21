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
        images[.보통] = [Image("player1"),Image("player2")]
        images[.파괴직전] = [Image("player3")]
        images[.공격당함] = [Image("player3"),Image("player4")]
        super.draw(context: context, screenSize: screenSize)
    }
}
