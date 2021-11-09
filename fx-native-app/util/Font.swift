//
//  Font.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/31.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

protocol FontDescriptionProtocol {
    static var name: String { get }
    static var type: String { get }
}

extension FontDescriptionProtocol {
    static func size(_ size: Int) -> UIFont {
        return UIFont(name: "\(name)-\(type)", size: CGFloat(size))!
    }
}

private protocol NotoSansProtocol: FontDescriptionProtocol {}
extension NotoSansProtocol {
    static var name: String {
        return "NotoSansKR"
    }
}

struct NotoSans {
    struct Black: NotoSansProtocol {
        static var type = "Black"
    }
    struct Bold: NotoSansProtocol {
        static var type = "Bold"
    }
    struct Light: NotoSansProtocol {
        static var type = "Light"
    }
    struct Medium: NotoSansProtocol {
        static var type = "Medium"
    }
    struct Regular: NotoSansProtocol {
        static var type = "Regular"
    }
    struct Thin: NotoSansProtocol {
        static var type = "Thin"
    }
}
