//
//  UIImage+Extensions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/25.
//

import Foundation
import SwiftUI

extension UIImage {
    func rotated(by degrees: CGFloat) -> UIImage? {
        let radians = degrees * CGFloat.pi / 180.0

        // 이미지 크기 계산
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        // 콘텍스트 생성
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // 이미지 회전 처리
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}
