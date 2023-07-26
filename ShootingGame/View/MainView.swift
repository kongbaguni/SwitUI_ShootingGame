//
//  MainView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        List {
            NavigationLink {
                GameCanvasView(isTestMode:false, level: 1,fps: 60)
            } label : {
                Text("Easy")
            }
            
            NavigationLink {
                GameCanvasView(isTestMode:false, level: 2,fps: 60)
            } label : {
                Text("Normal")
            }

            
            NavigationLink {
                GameCanvasView(isTestMode:false, level: 3,fps: 60)
            } label : {
                Text("Hard")
            }

            NavigationLink {
                GameCanvasView(isTestMode:false, level: 4,fps: 60)
            } label : {
                Text("Hell")
            }
            
            NavigationLink {
                GameCanvasView(isTestMode:true, level: 1,fps: 60)
            } label: {
                Text("Test Mode")
            }

        }
        .navigationTitle(Text("Home title"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
