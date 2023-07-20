//
//  UnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class UnitModel {
    enum Status {
        case 보통
        case 공격당함
        case 파괴직전
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
    }
    
    func healing(value:Int) {
        damage -= value
        if(damage < 0) {
            damage = 0
        }
    }

    
    
}
