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
    }
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        images[.보통] = [Image("player1"),Image("player2")]
        images[.파괴직전] = [Image("player3")]
        images[.공격당함] = [Image("player3"),Image("player4")]
        super.draw(context: context, screenSize: screenSize)
    }
}
