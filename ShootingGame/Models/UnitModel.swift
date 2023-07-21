//
//  UnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class UnitModel : NSObject {
    enum Status {
        case 보통
        case 공격당함
        case 파괴직전
        case 힐링
    }
    var status:Status = .보통
    var count = 0
    var screenSize:CGSize = .zero
    var center:CGPoint
    var range:CGFloat
    
    var images:[Status:[Image]] = [
        .보통 :[Image("unit")]
    ]
    
    var image:Image {
        if let arr = images[status] {
            return arr[count%arr.count]
        }
        return Image("unit")
    }
        
    init(center: CGPoint, range: CGFloat) {
        self.center = center
        self.range = range
    }
    
    var rect:CGRect {
        let x = center.x - range
        let y = center.y - range
        let w = range * 2
        return .init(x: x, y: y, width: w, height: w)
    }
        
    var isScreenOut:Bool {
        rect.isScreenOut(screenSize: screenSize)
    }
    
    func willScreenOut(vector:CGVector, ignore:CGRect.IgnoreDirection? = nil , padding:CGFloat = 0)->Bool {
        let newPoint = center + vector
        let newRect = CGRect(origin: .init(x: newPoint.x - range, y: newPoint.y - range), size: rect.size)
        return newRect.isScreenOut(screenSize: screenSize, ignore: ignore, padding: padding)
    }
    
    func draw(context:GraphicsContext, screenSize : CGSize) {
        
        context.draw(image, in: rect)
        self.screenSize = screenSize
        process()
    }
    
    func process() {
        count += 1
    }
    
    var hp:Int = 100
    var damage:Int = 0
    
    var isDie : Bool {
        damage > hp
    }
    
    func addDamage(value:Int) {
        damage += value
        status = .공격당함
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {[weak self] in
            self?.updateStatus()
        }
    }
    
    func healing(value:Int) {
        damage -= value
        if(damage < 0) {
            damage = 0
        }
        status = .힐링
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.updateStatus()            
        }
        updateStatus()
    }

    func updateStatus() {
        status = hp - damage > 10 ? .보통 : .파괴직전
    }
    
    func isCrash(unit:UnitModel)->Bool {
        let distance = center.distance(to: unit.center)
        return distance < range + unit.range
    }
    
}
