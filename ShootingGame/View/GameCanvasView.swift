//
//  GameCanvasView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

struct GameCanvasView : View {
    let fps:Int
    
    @State var count = 0
    @State var gameManager:GameManager = .init()
    
    @State var rotationAngle:CGFloat = 0
    var body: some View {
        VStack {
            Canvas { ctx, size in
                ctx.draw(Text("\(count)"), in: .init(origin: .init(x: -100, y: -100), size: .zero))
                gameManager.draw(context: ctx, screenSize: size)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000 / fps)) {
                    count += 1
                }
            }
            .background(Color.backGround2)
            .border(Color.primary, width: 2)
            .gesture(
                DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                    .onChanged({ value in
                        NotificationCenter.default.post(name: .dragPointerChanged, object: value)
                        
                    })
                    .onEnded({ value in
                        NotificationCenter.default.post(name: .dragEnded, object: value)
                    })
                
            )
            Button {
                gameManager.addUnit()
            } label: {
                Image(systemName: "plus.app")
                    .resizable()
                    .imageScale(.large)
                    .scaledToFit()
                    .frame(width: 80)
                
            }
        }
//        .edgesIgnoringSafeArea(.bottom)
//        .background(Color.backGround1)
    }
}

struct GameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView(fps: 60)
    }
}

