//
//  MainView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import SwiftUI
import GoogleMobileAds
import GameKit

struct MainView: View {
    struct GameCenterProfile {
        let displayName:String
        let gamePlayerID:String
        let teamPlayerID:String
    }
    
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
    @State var nativeAd:GADNativeAd? = nil
    @State var gameCenterProfile:GameCenterProfile? = nil
    
    let ad = GoogleAd()
    var body: some View {
        ScrollView {
            if AdLoader.shared.nativeAdsCount > 0 {
                CoinView(coin:$coin)
            }
            if let profile = gameCenterProfile {
                VStack {
                    HStack {
                        Text("GameCenter SignIn").font(.headline)
                        Text(":").font(.headline)
                        Text(profile.displayName).font(.headline)
                    }.foregroundColor(.white)
                    HStack {
                        Text("gamePlayerID").font(.caption)
                        Text(":").font(.caption)
                        Text(profile.gamePlayerID).font(.caption)
                    }.foregroundColor(.yellow.opacity(0.5))
                    HStack {
                        Text("teamPlayerID").font(.caption)
                        Text(":").font(.caption)
                        Text(profile.teamPlayerID).font(.caption)
                    }.foregroundColor(.yellow.opacity(0.5))
                }
                .padding(10)
                .background(.gray)
                .cornerRadius(10)
                .shadow(radius: 10,x:5,y:5)
            }
            
            RoundedButtonView(image: nil,
                              text: Text("Easy").foregroundColor(.white),
                              backgroundColor: .blue) {
                if coin > 0 || AdLoader.shared.nativeAdsCount == 0 {
                    coin -= 1
                    easy = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
            }
            RoundedButtonView(image: nil,
                              text: Text("Normal").foregroundColor(.white),
                              backgroundColor: .green) {
                if coin > 0 || AdLoader.shared.nativeAdsCount == 0 {
                    coin -= 1
                    normal = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
            }
            RoundedButtonView(image: nil,
                              text: Text("Hard").foregroundColor(.black),
                              backgroundColor: .orange) {
                if coin > 0 || AdLoader.shared.nativeAdsCount == 0 {
                    coin -= 1
                    hard = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
                    
                    
            }
            RoundedButtonView(image: nil,
                              text: Text("Hell").foregroundColor(.white),
                              backgroundColor: .red) {
                if coin > 0 || AdLoader.shared.nativeAdsCount == 0 {
                    coin -= 1
                    hell = true
                } else {
                    alertMessage = Text("coin empty desc");
                }
            }
            
            #if DEBUG
            NavigationLink {
                GameCanvasView(isTestMode:true, level: 1,fps: 60)
            } label: {
                Text("Test Mode")
            }.padding(.top, 30)
            #endif

            if nativeAd != nil {
                BannerAdView(sizeType: .GADAdSizeMediumRectangle)
            }
        }
        .onAppear {
            AdLoader.shared.getNativeAd { ad in
                nativeAd = ad
            }
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                
                if let err = error {
                    print(err.localizedDescription)
                }
                
                if let vc = viewController {
                    UIApplication.shared.lastViewController?.present(vc, animated: true)
                }
                
                if GKLocalPlayer.local.isAuthenticated {
                    gameCenterProfile = .init(
                        displayName: GKLocalPlayer.local.displayName,
                        gamePlayerID: GKLocalPlayer.local.gamePlayerID,
                        teamPlayerID: GKLocalPlayer.local.teamPlayerID)
                }
            }
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
