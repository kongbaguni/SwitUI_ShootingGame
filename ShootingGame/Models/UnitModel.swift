//
//  UnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

class UnitModel {
    var screenSize:CGSize = .zero
    var center:CGPoint
    var range:CGFloat
    var image:Image = Image("unit")
    
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

    }
    
    
    
}
