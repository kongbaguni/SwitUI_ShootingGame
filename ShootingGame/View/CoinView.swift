//
//  CoinView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/28.
//

import SwiftUI

struct CoinView: View {
    let ad = GoogleAd()
    @Binding var coin:Int
    @Binding var alert:Bool
    @Binding var alertType:MainView.AlertType
    var body: some View {
        HStack {
            if coin <= 0 {
                Button {
                    alert = true
                    alertType = .adwatch
                } label: {
                    Text("watch Ad and take coin")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.textColorStrong)
                }
            } else {
                HStack {
                    Text("Coin")
                    Text(":")
                    Text("\(coin)")
                }
            }
        }
        .padding(20)
      
    }
}

