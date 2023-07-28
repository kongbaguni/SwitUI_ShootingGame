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
        let btn = AdButton()
        btn.frame.size = size
        return btn
    }
            
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.frame.size = size
    }
    
}

class AdButton: UIView {
    init() {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        NotificationCenter.default.addObserver(forName: .setNativeAd, object: nil, queue: nil) { [weak self] noti in
            if let ad = noti.object as? GADNativeAd {
                ad.registerClickConfirmingView(self?.btn)
//                ad.register(UIView(),
//                            clickableAssetViews: [.callToActionAsset:btn],
//                            nonclickableAssetViews: [:])
                                
                self?.label.text = ad.headline
                self?.bodyLabel.text = ad.body
                self?.label.numberOfLines = 0
                self?.imageView.image = ad.icon?.image
                self?.imageView.layer.borderColor = self?.imageView.image != nil ? UIColor.black.cgColor : UIColor.clear.cgColor
                self?.imageView.layer.borderWidth = 1
                self?.btn.setTitle(ad.callToAction ?? "", for: .normal)
            }
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let imageView = UIImageView(frame: .init(x: 5, y: 5, width: 40, height: 40))
    let label = MarqueeLabel(frame: .init(x: 50, y: 0, width: UIScreen.main.bounds.width - 100, height: 25), duration: 8.0, fadeLength: 10.0)
    let bodyLabel = MarqueeLabel(frame: .init(x: 50, y: 25, width: UIScreen.main.bounds.width - 100, height: 25), duration: 8.0, fadeLength: 10.0)
    let btn = UIButton(frame: .init(x: UIScreen.main.bounds.width - 100, y: 0, width: 100, height: 50))
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(btn)
        addSubview(label)
        addSubview(imageView)
        addSubview(bodyLabel)
        
        label.autoresizingMask = [.flexibleWidth]
        btn.setTitleColor(.black, for: .normal)
        let btnW = btn.sizeThatFits(self.frame.size).width + 10
        btn.frame.size.width = btnW
        btn.frame.origin.x = UIScreen.main.bounds.width - btnW
        label.frame.size.width = UIScreen.main.bounds.width - imageView.frame.width - btnW
        bodyLabel.frame.size.width = label.frame.width
        
        btn.setTitleColor(.orange, for: .highlighted)
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(self.ouTouchup), for: .touchUpInside)
    }
//
    @objc func ouTouchup(_ sender: UIButton) {
        print("touch!!")

    }
}
