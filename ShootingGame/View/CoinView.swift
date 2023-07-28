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
            Text("coin : \(coin)")
            Button {
                ad.showAd { isSucess in
                    if isSucess {
                        coin += 1
                    }
                }
            } label: {
                Text("show Ad")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.textColorStrong)
            }
        }
    }
}

