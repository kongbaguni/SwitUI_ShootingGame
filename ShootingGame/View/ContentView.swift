//
//  ContentView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import SwiftUI

struct ContentView: View {
    init() {        
        GoogleAdPrompt.promptWithDelay {
            
        }
        _ = AdLoader.shared
    }
    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    MainView()
                        
                }
            }
            else {
                MainView()
            }
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
