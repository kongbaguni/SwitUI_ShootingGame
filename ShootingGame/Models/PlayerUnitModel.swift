//
//  PlayerUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class PlayerUnitModel : UnitModel {
    private var lastTouchLocaton:DragGesture.Value? = nil

    private var shotType:PlayerShotUnitModel.ShotType = .레이저
    private var power = 1
    public func powerUp(value:Int) {
        power += value
        if power >= 5 {
            power = 5
        }
        if power < 1 {
            power = 1
        }
    }
    
    private func toggleShotType() {
        switch shotType {
        case .레이저:
            shotType = .콩알탄
        case .콩알탄:
            shotType = .레이저
        }
    }
    
    override init(center: CGPoint, range: CGFloat) {
        super.init(center: center, range: range)
        isDrawHP = true

        imageNames[.보통] = ["player1","player2"]
        imageNames[.파괴직전] = ["player3"]
        imageNames[.공격당함] = ["player3","player4"]

        NotificationCenter.default.addObserver(forName: .dragPointerChanged, object: nil, queue: nil) { [weak self]noti in
            if let value = noti.object as? DragGesture.Value {
                let start = self?.lastTouchLocaton?.location ?? value.startLocation
                let vec = start.vector(to: value.location)
                if(self?.willScreenOut(vector: vec,ignore: nil,padding: -range) == false) {
                    self?.center += vec
                }
                self?.lastTouchLocaton = value
                NotificationCenter.default.post(name: .playerLocationWatch, object: self?.center)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .dragEnded, object: nil, queue: nil) { [weak self] noti in
            if let value = noti.object as? DragGesture.Value {
                print(value.location)
                if self?.isCrash(point: value.location, range: 50) == true {
                    self?.toggleShotType()
                }
            }
            
            self?.lastTouchLocaton = nil
            
        }
        
        NotificationCenter.default.addObserver(forName: .togglePlayerShotType, object: nil, queue: nil) { [weak self] noti in
            self?.toggleShotType()
        }
        
        NotificationCenter.default.addObserver(forName: .playerPowerUp, object: nil, queue: nil) { [weak self] _ in
            self?.powerUp(value:1)
        }
        
        NotificationCenter.default.addObserver(forName: .playerPowerDown, object: nil, queue: nil) { [weak self] _ in
            self?.powerUp(value: -1)
        }
        
        NotificationCenter.default.addObserver(forName: .playerPowerReset, object: nil, queue: nil) { [weak self] _ in
            self?.power = 1
        }
        
        
        pitanRange = 5
    }
    
    override func addDamage(value: Int) {
        if isDie {
            return
        }
        
        super.addDamage(value: value)
        
        if isDie {
            NotificationCenter.default.post(name: .unitDidDestoryed, object: self)
        }
    }
    
    override func process() {
        super.process()
        
        var shot:[PlayerShotUnitModel] = []
        switch shotType {
        case .레이저:
            shot = [
                .init(type:shotType,center: center + CGPoint(x: 0, y: -50), range: 10, movement: .init(dx: 0, dy: -10), speed: 5, atteck: power),
            ]
            
        case .콩알탄:
            let points:[[CGPoint]] = [
                [.init(x: 0, y: -10)],
                [.init(x:-4, y: -9), .init(x: 4, y: -9)],
                [.init(x:-8, y: -8), .init(x: 0, y: -10), .init(x: 8, y: -8)],
                [.init(x:-12, y: -6), .init(x: -4, y: -8), .init(x: 4, y: -8), .init(x: 12, y: -6)],
                [.init(x:-16, y: -6), .init(x: -8, y: -8), .init(x: 0, y: -10), .init(x: 8, y: -8), .init(x: 16, y: -6)]
            ]
            let idx = power - 1
            for point in points[idx] {
                shot.append(
                    .init(type:shotType,
                          center: center + point,
                          range: 10,
                          movement: .init(dx: point.x * 0.2, dy: point.y),
                          speed: 5,
                          atteck: 1)
                )
            }
        }
        
        if isDie == false {
            NotificationCenter.default.post(name: .makePlayerShot, object: shot)
        }
    }
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        if isDie {
            return
        }
        super.draw(context: context, screenSize: screenSize)
        var path = Path()
        path.addArc(center: center, radius: pitanRange, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
        
        context.stroke(path, with: .color(.red))
        context.fill(path, with: .color(.yellow))
    }

}
