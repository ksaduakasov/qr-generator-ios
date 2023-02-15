//
//  UIColor.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 14.02.2023.
//

import Foundation
import UIKit

extension UIColor {
    var hexString: String {
            let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
            let colorRef = cgColorInRGB.components
            let r = colorRef?[0] ?? 0
            let g = colorRef?[1] ?? 0
            let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
            let a = cgColor.alpha

            var color = String(
                format: "#%02lX%02lX%02lX",
                lroundf(Float(r * 255)),
                lroundf(Float(g * 255)),
                lroundf(Float(b * 255))
            )

            if a < 1 {
                color += String(format: "%02lX", lroundf(Float(a * 255)))
            }

            return color
        }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (UInt32(int) >> 8) * 17, (UInt32(int) >> 4 & 0xF) * 17, (UInt32(int) & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, UInt32(int) >> 16, UInt32(int) >> 8 & 0xFF, UInt32(int) & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (UInt32(int) >> 24, UInt32(int) >> 16 & 0xFF, UInt32(int) >> 8 & 0xFF, UInt32(int) & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
