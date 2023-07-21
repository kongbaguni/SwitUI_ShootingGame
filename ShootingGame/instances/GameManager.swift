//
//  GameManager.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class GameManager {
    
    var units:[UnitModel] = []
    var screenSize:CGSize = .zero
    var player = PlayerUnitModel(center: .init(x: 100, y: 100), range: 50)
    func addUnit() {
        let c = CGPoint(x: .random(in: 50...350), y: -100)
        let unit = EnemyUnitModel(center: c, range: .random(in: 50...70), movement: .init(dx: 0, dy: .random(in: 1...2)), speed: .random(in: 0.1...1))
        units.append(unit)
        print(units.count)
    }
    
    func draw(context:GraphicsContext, screenSize:CGSize) {
        self.screenSize = screenSize
        context.draw(Text("unitCount: \(units.count)"), in: .init(x: 30, y: 30, width: 200, height: 100))
        for (idx,unit) in units.enumerated() {
            unit.draw(context: context,screenSize: screenSize)
            if unit.isScreenOut {
                units.remove(at: idx)
            }
        }
        player.draw(context: context, screenSize: screenSize)
        
    }
    
}
