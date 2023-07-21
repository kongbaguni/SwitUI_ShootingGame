//
//  EnemyUnitModel.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI
import GoogleMobileAds
#if DEBUG
fileprivate let adId = "ca-app-pub-3940256099942544/3986624511"
#else
fileprivate let adId = "ca-app-pub-7714069006629518/8836977450"
#endif


class EnemyUnitModel : MovementUnitModel {
    let adLoader:GADAdLoader
    var nativeAd:GADNativeAd? = nil
    override init(center: CGPoint, range: CGFloat, movement: CGVector, speed: CGFloat) {
        let option = GADMultipleAdsAdLoaderOptions()
        option.numberOfAds = 1
        self.adLoader = GADAdLoader(adUnitID: adId,
                                    rootViewController: UIApplication.shared.lastViewController,
                                    adTypes: [.native], options: [option])
        super.init(center: center, range: range, movement: movement, speed: speed)
        isDrawHP = true
        images[.보통] = [Image("star1")]
        images[.공격당함] = [Image("star3")]
        images[.파괴직전] = [Image("star2")]
        adLoader.delegate = self
        loadAd()
        hp = 800
    }
    
    func loadAd() {
        adLoader.delegate = self
        adLoader.load(.init())
    }
    
    override func draw(context: GraphicsContext, screenSize: CGSize) {
        super.draw(context: context, screenSize: screenSize)
        if let ad = nativeAd {
            switch status {
            case .보통:
                context.fill(Path(rect), with: .color(Color("dim")))
                if let headline = ad.headline {
                    context.draw(Text(headline).font(.headline),
                                 in: .init(x: center.x - range,
                                           y: center.y - range,
                                           width: range * 2,
                                           height: range))
                }
                if let str = ad.body {
                    context.draw(Text(str).font(.caption),
                                 in: .init(x: center.x - range,
                                           y: center.y,
                                           width: range * 2,
                                           height: range))
                }
            default:
                break
            }
            
        }
    }
    override var isScreenOut: Bool {
        rect.isScreenOut(screenSize: screenSize, ignore: .top)
    }
}

extension EnemyUnitModel : GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("\(#function) \(#line)")
        if let image = nativeAd.icon?.image {
            images[.보통] = [Image(uiImage: image)]
        }
        if let image = nativeAd.images?.first?.image {
            images[.공격당함] = [Image(uiImage: image)]
        }
        if let image = nativeAd.images?.last?.image {
            images[.파괴직전] = [Image(uiImage: image)]
        }
        self.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(#function) \(#line)")
        print(error.localizedDescription)
    }

}
