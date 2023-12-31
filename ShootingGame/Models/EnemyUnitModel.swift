//
//  EnemyUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class EnemyUnitModel : MovementUnitModel {
    enum EnemyShotType {
        case 일번샷
        case 이번샷
        case 삼번샷
        case 조준샷
    }
    let shotTypes:[EnemyShotType]
    var target:CGPoint? = nil
    var targetRefashPause = false
    var targetVector:CGVector?  {
        if let t = target {
            return center.directionVector(to: t, withSpeed: 50)
        }
        return nil
    }
    
    let dropItem:[ItemUnitModel.ItemType]
    var nativeAd:GADNativeAd? = nil {
        didSet {
            if let ad = nativeAd {
                ad.rootViewController = UIApplication.shared.lastViewController
            }
        }
    }
    
    override var imageRotateAngle: CGFloat {
        return movement.angleInRadians
        
    }

    override func addDamage(value: Int) {
        if isDie {
            return
        }
        super.addDamage(value: value)
        if isDie {
            NotificationCenter.default.post(name: .setNativeAd, object: nativeAd)
        }
    }
    init(center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat, shotTypes:[EnemyShotType], dropItem:[ItemUnitModel.ItemType]) {
        self.dropItem = dropItem
        self.shotTypes = shotTypes
        super.init(center: center, range: range, movement: movement, speed: speed)
        isDrawHP = true
        imageNames[.보통] = ["star1"]
        imageNames[.공격당함] = ["star3"]
        imageNames[.파괴직전] = ["star2"]

        hp = .random(in: 200..<400)
        
        NotificationCenter.default.addObserver(forName: .playerLocationWatch, object: nil, queue: nil) { [weak self] noti in
            if self?.targetRefashPause == false {
                self?.target = noti.object as? CGPoint
            }
        }
    }
    
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        super.draw(context: context, screenSize: screenSize)
        if nativeAd == nil {
            nativeAd = AdLoader.shared.nativeAd
        }
        if let ad = nativeAd {
            if let img = ad.icon?.image {
                images[.보통] = [img]
            }
            if let img = ad.images?.first?.image {
                images[.공격당함] = [img]
            }
            if let img = ad.images?.last?.image {
                images[.파괴직전] = [img]
            }
            switch status {
            case .공격당함:
                context.fill(Path(rect), with: .color(Color("dim")))
                if let headline = ad.headline {
                    context.draw(Text(headline).font(.headline),
                                 in: .init(x: center.x - range,
                                           y: center.y - range,
                                           width: range * 2,
                                           height: range))
                }
                if let str = ad.body {
                    context.draw(Text(str).font(.caption),
                                 in: .init(x: center.x - range,
                                           y: center.y,
                                           width: range * 2,
                                           height: range))
                }
            default:
                break
            }
        }
        if let targetVector = targetVector {
            var path = Path()
            path.addArc(center: center, radius: 5, startAngle: .zero, endAngle: Angle(degrees: 360), clockwise: true)
            path.addArc(center: center + targetVector, radius: 5, startAngle: .zero, endAngle: Angle(degrees: 360), clockwise: true)
            context.fill(path, with: .color(.blue))

            var path2 = Path()
            let a = center
            let b = center + targetVector
            let c = b + targetVector.rotated(by: 90)
            let d = b + targetVector.rotated(by: -90)
            
            path2.move(to: a)
            path2.addLines([a,b,c,b,d,b,a])
            context.stroke(path2 , with: .color(.blue))
        }
        
    }
    
    override func process() {
        super.process()
        makeShot()
        
    }
    
    override var isScreenOut: Bool {
        rect.isScreenOut(screenSize: screenSize, ignore: .top)
    }
    
    var shotIdx = 0
    
    var nextShotIdx:Int {
        shotIdx += 1
        if shotIdx >= shotTypes.count {
            shotIdx = 0
        }
        return shotIdx
    }
    
    func makeShot() {
        var shots:[EnemyShotUnitModel] = []
        switch shotTypes[shotIdx] {
        case .일번샷:
            if count % 30 == 0 {
                for i in 0...12 {
                    shots.append(.init(
                        center: center,
                        range: 5,
                        movement: .init(dx: sin(Double(count+i)), dy: cos(Double(count+i))),
                        speed: 2,
                        type: .일반,
                        colors: (.yellow,.red)
                    ))
                }
            } else if count % 150 == 149 {
              shotIdx = nextShotIdx
            }

        case .이번샷:
            if count % 150 < 100 {
                shots.append(.init(
                    center: center,
                    range: 5,
                    movement: .init(dx: cos(Double(count % 100)), dy: sin(Double(count % 100))),
                    speed: 2, type: .일반,
                    colors: (.orange,.black)
                ))
            } else if count % 150 == 149 {
                shotIdx = nextShotIdx
            }
            
        case .삼번샷:
            if count % 200 < 50 {
                shots.append(.init(center: center + .random(range: -10..<10),
                                   range: .random(in: 5..<10),
                                   movement: .init(dx: tan(Double(count)), dy: cos(Double(count))),
                                   speed: .random(in: 2...4),
                                   type: .일반,
                                   colors: (.blue,.gray)
                                  ))
            }
            
        case .조준샷:
            guard let t = target else {
                return
            }
            if count % 150 < 100  {
                targetRefashPause = true
//                isMovingPause = true
                let v = center.directionVector(to: t, withSpeed: 2)
                shots.append(.init(center: center + v , range: 20, movement: v, speed:2, type: .추적레이저빔, colors: (.mint,.indigo)))
            }
            else if count % 150 == 149 {
                shotIdx = nextShotIdx
            }
            else {
//                isMovingPause = false
                targetRefashPause = false                
            }
        }
        
        NotificationCenter.default.post(name: .makeEnemyShot, object: shots)
    }
}

