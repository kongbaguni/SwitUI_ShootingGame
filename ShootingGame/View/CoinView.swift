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
    
    var body: some View {
        HStack {
            if coin <= 0 {
                Button {
                    ad.showAd { isSucess in
                        if isSucess {
                            coin += 5
                        }
                    }
                } label: {
                    Text("watch Ad and take coin")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.textColorStrong)
                }
            } else {
                Text("Coin : \(coin)")
            }
        }
        .padding(20)
    }
}

