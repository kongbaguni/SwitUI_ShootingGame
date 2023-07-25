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
    var status:Status = .보통 {
        didSet {
            statusChangeDate = Date()
        }
    }
    
    var statusChangeDate = Date()
    var count = 0
    var screenSize:CGSize = .zero
    var center:CGPoint
    /** 뷰 사이즈*/
    var range:CGFloat
    /** 피탄 판정 범위 */
    var pitanRange:CGFloat
    
    var images:[Status:[UIImage]] = [:]
    
    var imageNames:[Status:[String]] = [
        .보통 :["unit"]
    ]
    
    var image:UIImage {        
        if let arr = images[status] {
            return arr[count%arr.count]
        }
        
        if let arr = imageNames[status] {
            return UIImage(named: arr[count%arr.count])!
        }
        return UIImage(named: "unit")!
    }
        
    init(center: CGPoint, range: CGFloat) {
        self.center = center
        self.range = range
        self.pitanRange = range
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
    
    var isDrawHP = false
    
    var imageRotateAngle:CGFloat {
        return 0
    }
    
    func draw(context:GraphicsContext, screenSize : CGSize) {
        context.draw(Image(uiImage: image), in: rect)
        if let images = images[status] {
            let image = images[count%images.count]
            context.draw(Image(uiImage: image), in: rect)
        }
        if isDrawHP {
            let r1 = CGRect(x: center.x - range, y: center.y + range + 10, width: range * 2, height: 5)
            let h = Double(hp - damage) / Double(hp)
            let r2 = CGRect(origin: r1.origin, size: .init(width: range * 2 * h, height: 5))
            context.stroke(Path(roundedRect: r1, cornerSize: .init(width: 5, height: 5)), with:.foreground)
            context.fill(Path(roundedRect: r2, cornerSize: .init(width: 5, height: 5)), with: .color(.textColorStrong))
        }
        self.screenSize = screenSize
        process()
    }
    
    func process() {
        count += 1
        updateStatus()
    }
    
    var hp:Int = 100
    var damage:Int = 0
    var atteck:Int = 1
    var isDie : Bool {
        damage > hp
    }
    
    func addDamage(value:Int) {
        damage += value
        status = .공격당함
    }
    
    func healing(value:Int) {
        damage -= value
        if(damage < 0) {
            damage = 0
        }
        status = .힐링
    }

    func updateStatus() {
        let interval = Date().timeIntervalSince1970 - statusChangeDate.timeIntervalSince1970 
        if interval >= 0.5 {
            status = hp - damage > 10 ? .보통 : .파괴직전
        }
    }
    
    func isCrash(unit:UnitModel)->Bool {
        let distance = center.distance(to: unit.center)
        return distance < pitanRange + unit.pitanRange
    }
    
}
