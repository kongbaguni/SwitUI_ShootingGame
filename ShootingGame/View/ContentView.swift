//
//  ContentView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import SwiftUI

struct ContentView: View {
    
    var game: some View {
        GameCanvasView(fps: 60)
    }
    var toolbarItem : some View {
        NavigationLink {
            EmptyView()
        } label: {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.textColorStrong)
        }

    }
    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    game
                }
                .toolbar {
                    toolbarItem
                }
            } else {
                game
                .toolbar {
                    toolbarItem
                }
            }
        }.background(Color.backGround3)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
