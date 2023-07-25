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
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .아군미사일폭발, lifeLength: 30))
            }
        }
        
    }
    
    func draw(context: GraphicsContext) {
        for (idx,item) in items.enumerated() {
            switch item.type {
            case .적군미사일폭발:
                break
            case .아군미사일폭발:
                var path = Path()
                for i in 0...3 {
                    path.addArc(center: item.center + .init(x: .random(in: -3...3), y: .random(in: -3...3)), radius: item.rect.width / 2 + CGFloat(10 * i + item.count * 5), startAngle: .zero, endAngle: Angle(degrees: 360), clockwise: true)
                }
                let opacity = 1.0 - Double(item.count) / Double(item.lifeLength)
                context.stroke(path, with: .color(.red.opacity(opacity)))
                if Int.random(in: 0...10) == 0 {
                    context.fill(path, with: .color(.orange.opacity(opacity / 2)))
                }
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
