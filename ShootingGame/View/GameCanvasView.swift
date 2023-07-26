//
//  GameCanvasView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI

struct GameCanvasView : View {
    let isTestMode:Bool
    let level:Int
    let fps:Int
    
    @State var count = 0
    @State var gameManager:GameManager? = nil
    
    @State var rotationAngle:CGFloat = 0
    
    var navigationTitle:Text {
        if isTestMode {
           return Text("Test Mode")
        }
        switch level {
        case 1:
            return Text("Easy")
        case 2:
            return Text("Normal")
        case 3:
            return Text("Hard")
        case 4:
            return Text("Hell")
        default:
            return Text("")
        }
    }
    
    var body: some View {
        VStack {
            Canvas { ctx, size in
                gameManager?.isTestMode = isTestMode
                
                ctx.draw(Text("\(count)"), in: .init(origin: .init(x: -100, y: -100), size: .zero))
                gameManager?.draw(context: ctx, screenSize: size)
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
            if isTestMode {
                Button {
                    gameManager?.addUnit()
                } label: {
                    Image(systemName: "plus.app")
                        .resizable()
                        .imageScale(.large)
                        .scaledToFit()
                        .frame(width: 80)
                }
            }
        }
        .onAppear {
            gameManager = .init()
            gameManager?.level = level
        }
        .onDisappear {
            gameManager?.clear()
        }
        .navigationTitle(navigationTitle)        
        .navigationBarTitleDisplayMode(.inline)

    }
    
}

struct GameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView(isTestMode: true,level: 1, fps: 60)
    }
}

