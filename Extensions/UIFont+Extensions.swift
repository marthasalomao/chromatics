//
//  UIFont+Extensions.swift
//  Chromatics
//
//  Created by Martha on 18/01/24.
//

import Foundation
import UIKit

struct Fonts {
    static let avenirNextLTProBold = "AvenirNextLTPro-Bold"
    static let avenirNextLTProIt = "AvenirNextLTPro-It"
    static let avenirNextLTProRegular = "AvenirNextLTPro-Regular"
}

extension UIFont {
    static func avenirNextLTProBold(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.avenirNextLTProBold, size: size)
    }
    
    static func AvenirNextLTProIt(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.avenirNextLTProIt, size: size)
    }
    
    static func AvenirNextLTProRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.avenirNextLTProRegular, size: size)
    }
}

