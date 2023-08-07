//
//  NativeAdClickView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/28.
//

import Foundation
import UIKit
import SwiftUI
import GoogleMobileAds
import MarqueeLabel

struct NaticeAdClidkView : UIViewRepresentable {
    let size:CGSize    
    
    func makeUIView(context: Context) -> some UIView {
        let btn = UIView()
        btn.frame.size = size
        NotificationCenter.default.addObserver(forName: .setNativeAd, object: nil, queue: nil) { [self] noti in
            if let ad = noti.object as? GADNativeAd {
                for view in btn.subviews {
                    view.removeFromSuperview()
                }
                let view = UnifiedNativeAdView(ad: ad, frame: .init(origin: .zero, size: .init(width: size.width, height: size.height)))
                btn.addSubview(view)
            }
        }
        return btn
    }
            
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.frame.size = size
    }
    
}
