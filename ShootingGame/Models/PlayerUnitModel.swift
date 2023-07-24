//
//  PlayerUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class PlayerUnitModel : UnitModel {
    var lastTouchLocaton:DragGesture.Value? = nil

    override init(center: CGPoint, range: CGFloat) {
        super.init(center: center, range: range)
        isDrawHP = true

        images[.보통] = [Image("player1"),Image("player2")]
        images[.파괴직전] = [Image("player3")]
        images[.공격당함] = [Image("player3"),Image("player4")]

        NotificationCenter.default.addObserver(forName: .dragPointerChanged, object: nil, queue: nil) { [weak self]noti in
            if let value = noti.object as? DragGesture.Value {
                let start = self?.lastTouchLocaton?.location ?? value.startLocation
                let vec = start.vector(to: value.location)
                if(self?.willScreenOut(vector: vec,ignore: nil,padding: -range) == false) {
                    self?.center += vec
                }
                print("-------")
                self?.lastTouchLocaton = value
            }
        }
        NotificationCenter.default.addObserver(forName: .dragEnded, object: nil, queue: nil) { [weak self] noti in
            self?.lastTouchLocaton = nil
        }
        pitanRange = 5
    }
    
    override func process() {
        super.process()
        let shot = PlayerShotUnitModel(center: center + CGPoint(x: 0, y: -50), range: 10, movement: .init(dx: 0, dy: -10), speed: 5)
        NotificationCenter.default.post(name: .makePlayerShot, object: shot)
    }
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        super.draw(context: context, screenSize: screenSize)
        var path = Path()
        path.addArc(center: center, radius: pitanRange, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
        
        context.stroke(path, with: .color(.red))
        context.fill(path, with: .color(.yellow))
    }

}
