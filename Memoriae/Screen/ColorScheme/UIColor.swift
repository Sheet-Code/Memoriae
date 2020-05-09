//
//  UIColor.swift
//  Memoriae
//
//  Created by panandafog on 06.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

public extension UIColor {

    var codedString: String? {

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            return data.base64EncodedString()
        } catch _ {

            return nil
        }
    }

    static func color(withCodedString string: String) -> UIColor? {

        guard let data = Data(base64Encoded: string) else {
            return nil
        }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }

    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + additionalSaturation,
                           brightness: currentBrigthness + additionalBrightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
}
