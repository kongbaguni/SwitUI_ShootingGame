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
        case 아이템먹었다
    }
    let uuid = "\(UUID().uuidString)\(Date().timeIntervalSince1970)"
    let center:CGPoint
    let rect:CGRect
    let type:ParticleType
    let lifeLength:Int
    let text:String?
    var count:Int = 0
}

class Particle {
    var items:[ParticleItem] = []
    
    init() {        
        NotificationCenter.default.addObserver(forName: .unitDidDestoryed, object: nil, queue: nil) {[weak self] noti in
            if let obj = noti.object as? PlayerShotUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .아군미사일폭발, lifeLength: 10, text: nil))
            }
            if let obj = noti.object as? EnemyShotUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .적군미사일폭발, lifeLength: 10, text: nil))
            }
            if let obj = noti.object as? EnemyUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .적기폭발, lifeLength: 30, text: nil))
            }
            if let obj = noti.object as? PlayerUnitModel {
                self?.items.append(.init(center: obj.center, rect: obj.rect, type: .아군기폭발, lifeLength: 20, text: nil))
            }
        }
        
        NotificationCenter.default.addObserver(forName: .itemGet, object: nil, queue: nil) { [weak self]  noti in
            if let item = noti.object as? ItemUnitModel {
                self?.items.append(.init(center: item.center,
                                         rect: item.rect,
                                         type: .아이템먹었다,
                                         lifeLength: 50,
                                         text : "\(item.atteck)"
                                        ))
            }
                
        }
    }
    
    func draw(context: GraphicsContext) {
        for (idx,item) in items.enumerated() {
            let opacity = 1.0 - Double(item.count) / Double(item.lifeLength)
            
            switch item.type {
            case .아이템먹었다:
                if let txt = item.text {
                    context.draw(
                        Text(txt)
                            .font(.system(size: 5 + CGFloat(item.count) * 0.5))
                            .foregroundColor(.textColorStrong.opacity(opacity)),
                        in: item.rect + CGFloat(item.count))
                }
                
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
                context.stroke(path, with: .color(.primary.opacity(opacity)))
            case .아군기폭발:
                var path = Path()
                for i in 0...3 {
                    path.addRect(item.rect + i * 20 - item.count * 10)
                }
                context.stroke(path, with: .color(.primary.opacity(opacity)))
                               
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
