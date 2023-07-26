//
//  Array+Extensions.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/26.
//

import Foundation
extension Array where Element: Collection {
    func flatten2DArray() -> [Element.Element] {
        var result = [Element.Element]()
        for subArray in self {
            result.append(contentsOf: subArray)
        }
        return result
    }
}
