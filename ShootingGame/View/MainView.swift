//
//  MainView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import SwiftUI

struct MainView: View {
    @AppStorage("coin") var coin:Int = 0
    @State var easy = false
    @State var normal = false
    @State var hard = false
    @State var hell = false
    @State var alertMessage:Text? = nil {
        willSet {
            if newValue != nil {
                alert = true
            }
        }
    }
    @State var alert = false
    let ad = GoogleAd()
    var body: some View {
        ScrollView {
            CoinView(coin:$coin)
            
            RoundedButtonView(image: nil, text: Text("Easy")) {
                if coin > 0 {
                    coin -= 1
                    easy = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
            }
            RoundedButtonView(image: nil, text: Text("Normal")) {
                if coin > 0 {
                    coin -= 1
                    normal = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
            }
            RoundedButtonView(image: nil, text: Text("Hard")) {
                if coin > 0 {
                    coin -= 1
                    hard = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
                    
                    
            }
            RoundedButtonView(image: nil, text: Text("Hell")) {
                if coin > 0 {
                    coin -= 1
                    hell = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
            }
            
            BannerAdView(sizeType: .GADAdSizeLargeBanner)
                .padding(.top, 30)
            
            NavigationLink {
                GameCanvasView(isTestMode:true, level: 1,fps: 60)
            } label: {
                Text("Test Mode")
            }.padding(.top, 30)
            
        }
        .alert(isPresented: $alert, content: {
            .init(title: Text("alert"), message: alertMessage)
        })
        .navigationDestination(isPresented: $easy, destination: {
            GameCanvasView(isTestMode:false, level: 1,fps: 60)
        })
        .navigationDestination(isPresented: $normal, destination: {
            GameCanvasView(isTestMode:false, level: 2,fps: 60)
        })
        .navigationDestination(isPresented: $hard, destination: {
            GameCanvasView(isTestMode:false, level: 3,fps: 60)
        })
        .navigationDestination(isPresented: $hell, destination: {
            GameCanvasView(isTestMode:false, level: 4,fps: 60)
        })

        .navigationTitle(Text("Home title"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
