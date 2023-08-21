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
    @State var alert = false
    var body: some View {
        HStack {
            if coin <= 0 {
                Button {
                    alert = true                  
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
        .alert(isPresented: $alert) {
            .init(title: Text("watch ad alert title"), message: Text("watch ad alert msg"), primaryButton: .default(Text("confirm"), action:{
                ad.showAd { isSucess in
                    if isSucess {
                        coin += 10
                    }
                }
            }), secondaryButton: .cancel())
        }
    }
}

