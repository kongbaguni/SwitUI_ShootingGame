//
//  GoogleADViewController.swift
//  firebaseTest
//
//  Created by Changyul Seo on 2020/03/13.
//  Copyright © 2020 Changyul Seo. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleMobileAds

#if DEBUG
fileprivate let rewordGaId = "ca-app-pub-3940256099942544/6978759866" // test ga id
fileprivate let bannerGaId = "ca-app-pub-3940256099942544/2934735716" // test ga id
#else
fileprivate let rewordGaId = "ca-app-pub-7714069006629518/7115065196" // real ga id
fileprivate let bannerGaId = "ca-app-pub-7714069006629518/2493293907" // real ga id
#endif


class GoogleAd : NSObject {
    
    var interstitial:GADRewardedInterstitialAd? = nil
    
    var isGetReword = false
    private func loadAd(complete:@escaping(_ isSucess:Bool)->Void) {
        let request = GADRequest()
        
        GADRewardedInterstitialAd.load(withAdUnitID: rewordGaId, request: request) { [weak self] ad, error in
            if let err = error {
                print("google ad load error : \(err.localizedDescription)")
            }
            ad?.fullScreenContentDelegate = self
            self?.interstitial = ad
            complete(ad != nil)
        }
    }
    
    var callback:(_ isSucess:Bool)->Void = { _ in}
    var requested = false
    func showAd(complete:@escaping(_ isSucess:Bool)->Void) {
//        if Date().timeIntervalSince1970 - (UserDefaults.standard.lastGoogleAdWatchTime?.timeIntervalSince1970 ?? 0) < 60 * 30 {
//            complete(false)
//            return
//        }
        isGetReword = false
        if requested {
            return
        }
        requested = true
        callback = complete
        loadAd { [weak self] isSucess in
            if isSucess == false {
                DispatchQueue.main.async {
                    complete(false)
                }
                return
            }
            if let vc = UIApplication.shared.lastViewController {
                self?.interstitial?.present(fromRootViewController: vc, userDidEarnRewardHandler: {
                    self?.isGetReword = true
                    self?.requested = false
                    print("rewoard get")
                })
            }
        }
    }
     
    
}

extension GoogleAd : GADFullScreenContentDelegate {
    //광고 실패
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("google ad \(#function)")
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.callback(false)
        }
    }
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
    }
    //광고시작
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
    }
    //광고 종료
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("google ad \(#function)")
        UserDefaults.standard.lastGoogleAdWatchTime = Date()
        let isGetReword = self.isGetReword
        DispatchQueue.main.async {
            self.callback(isGetReword)
        }
    }
}

struct GoogleAdBannerView: UIViewRepresentable {
    let bannerView:GADBannerView
    func makeUIView(context: Context) -> GADBannerView {
        bannerView.adUnitID = bannerGaId
        bannerView.rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return bannerView
    }
  
  func updateUIView(_ uiView: GADBannerView, context: Context) {
      uiView.load(GADRequest())
  }
}

