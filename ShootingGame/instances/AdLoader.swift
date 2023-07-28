//
//  AdLoader.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/27.
//

import Foundation
import GoogleMobileAds
#if DEBUG
fileprivate let adId = "ca-app-pub-3940256099942544/3986624511"
#else
fileprivate let adId = "ca-app-pub-7714069006629518/8836977450"
#endif
class AdLoader : NSObject {
    static let shared = AdLoader()
    
    private let adLoader:GADAdLoader
    public var nativeAds:[String:GADNativeAd] = [:]
    private var isPause = false
    
    override init() {
        let option = GADMultipleAdsAdLoaderOptions()
        option.numberOfAds = 10
        adLoader = GADAdLoader(adUnitID: adId,
                                    rootViewController: UIApplication.shared.lastViewController,
                                    adTypes: [.native], options: [option])
        super.init()
        adLoader.delegate = self
        loadAd()
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] noti in
            self?.isPause = true
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) {[weak self] noti in
            self?.isPause = false
            self?.loadAd()
        }
    }
    
    func loadAd() {
        if isPause == false {
            adLoader.load(.init())
        }
    }    
    
}

extension AdLoader : GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("\(#function) \(#line)")
        nativeAds[nativeAd.headline ?? nativeAd.description] = nativeAd
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(30)) { [self] in
            loadAd()
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(#function) \(#line)")
        print(error.localizedDescription)
    }
    
}

