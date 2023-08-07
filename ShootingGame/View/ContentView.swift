//
//  ContentView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import SwiftUI
import FirebaseCore

struct ContentView: View {
    init() {        
        GoogleAdPrompt.promptWithDelay {
            
        }
        _ = AdLoader.shared
        FirebaseApp.configure()
    }
    var body: some View {
        NavigationView {
            NavigationStack {
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
