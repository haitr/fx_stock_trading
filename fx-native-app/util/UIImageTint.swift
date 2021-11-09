//
//  UIImageTint.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/17.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

extension UIImage {
    //
    /// Tint Image
    ///
    /// - Parameter fillColor: UIColor
    /// - Returns: Image with tint color
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))

        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()
        return imageColored
    }
}
