//
//  Theme.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/10.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}

enum Theme {
    static let clear           = UIColor.clear
    static let darkThree       = UIColor(named : "darkThree")!
    static let iceBlue         = UIColor(named : "iceBlue")!
    static let blueGreyTwo     = UIColor(named : "blueGreyTwo")!
    static let darkFive        = UIColor(named : "darkFive")!
    static let darkTwo         = UIColor(named : "darkTwo")!
    static let cornflowerThree = UIColor(named : "cornflowerThree")!
    static let slateThree      = UIColor(named : "slateThree")!
    static let white5          = UIColor(named : "white5")!
    static let darkSix         = UIColor(named : "darkSix")!
    static let yellowOrange    = UIColor(named : "yellowOrange")!
    static let dodgerBlue      = UIColor(named : "dodgerBlue")!
    static let darkTwoTwo64    = UIColor(named : "darkTwoTwo64")!
    static let lightBlueGrey   = UIColor(named : "lightBlueGrey")!
    static let charcoalGrey    = UIColor(named : "charcoalGrey")!
    static let blueGrey12      = UIColor(named : "blueGrey12")!
    static let blueGrey        = UIColor(named : "blueGrey")!
    static let veryLightBlue   = UIColor(named : "veryLightBlue")!
    static let slateTwo39      = UIColor(named : "slateTwo39")!
    static let slateFour       = UIColor(named : "slateFour")!
    static let cloudyBlue      = UIColor(named : "cloudyBlue")!
    
    static let statusBar           = UIStatusBarStyle.lightContent
    static let navigationBarHeight = 44
    
    static let radioSnE        = UIImage(named: "radioBtnSOn")! // selected & enabled
    static let radioSnD        = UIImage(named: "radioBtnSOff")! // selected & disabled
    static let radioBtnDefault = UIImage(systemName: "circle")?.tint(with: Theme.slateThree) // unselected
    
    static func statusBarHeight(_ window: UIWindow?) -> Int {
        var x: CGFloat?
        if #available(iOS 13, *) {
            x = window?.windowScene?.statusBarManager?.statusBarFrame.height
        } else {
            x = UIApplication.shared.statusBarFrame.size.height
        }
        return Int(x ?? 0)
    }
}
