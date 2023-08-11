//
//  LeaderBoardView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/08/08.
//

import SwiftUI
import GameKit

struct LeaderBoardView: View {
    let leaderBoardId:String
    var body: some View {
        
        List {
            Text("LeaderBoard")
            
        }.onAppear {
            
            
        }
        
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView(leaderBoardId: "easy")
    }
}
