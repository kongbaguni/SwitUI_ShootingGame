//
//  Effector.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/25.
//

import Foundation
import SwiftUI

struct ParticleItem : Equatable{
    static func == (left:ParticleItem, right:ParticleItem) -> Bool {
        return left.uuid == right.uuid
    }
    enum ParticleType {
        case 아군미사일폭발
        case 적군미사일폭발
        case 적기폭발
        case 아군기폭발
    }
    let uuid = "\(UUID().uuidString)\(Date().timeIntervalSince1970)"
    let center:CGPoint
    let rect:CGRect
    let type:ParticleType
    let lifeLength:Int
    var count:Int = 0
}

class Particle {
    var items:[ParticleItem] = []
    
    init() {        
        NotificationCenter.default.addObserver(forName: .unitDidDestoryed, object: nil, queue: nil) {[weak self] noti in
            if let obj = noti.object as? PlayerShotUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .아군미사일폭발, lifeLength: 10))
            }
            if let obj = noti.object as? EnemyShotUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .적군미사일폭발, lifeLength: 10))
            }
            if let obj = noti.object as? EnemyUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .적기폭발, lifeLength: 30))
            }
        }
        
    }
    
    func draw(context: GraphicsContext) {
        for (idx,item) in items.enumerated() {
            let opacity = 1.0 - Double(item.count) / Double(item.lifeLength)
            
            switch item.type {
            case .적군미사일폭발:
                let c = item.count
                var path = Path()
                let s = Double(c) / 2
                if c%2 == 0 {
                    path.addRect(.init(
                        x: item.rect.origin.x - s,
                        y: item.rect.origin.y - s,
                        width: item.rect.size.width + s * 2,
                        height: item.rect.size.height + s * 2))
                }
                else {
                    path.addArc(center: item.center,
                                radius: s,
                                startAngle: .zero,
                                endAngle: .init(degrees: 360),
                                clockwise: true)
                }
                context.stroke(path, with: .color(.blue))
                
            case .아군미사일폭발:
                var path = Path()
                for i in 0...3 {
                    path.addArc(center: item.center + .init(x: .random(in: -3...3), y: .random(in: -3...3)), radius: item.rect.width / 2 + CGFloat(10 * i + item.count * 5), startAngle: .zero, endAngle: Angle(degrees: 360), clockwise: true)
                }
                
                context.stroke(path, with: .color(.red.opacity(opacity)))
                if Int.random(in: 0...10) == 0 {
                    context.fill(path, with: .color(.orange.opacity(opacity / 2)))
                }
                
            case .적기폭발:
                var path = Path()
                for i in 0...3 {
                    path.addRect(item.rect + i * 10 - item.count * 10)
                }
                context.stroke(path, with: .color(.black.opacity(opacity)))
            default:
                break
            }
            if idx < items.count {
                items[idx].count += 1
            }

            if item.count > item.lifeLength {
                if let idx = items.firstIndex(of: item) {
                    items.remove(at: idx)
                }
            }
        }
    }
}
