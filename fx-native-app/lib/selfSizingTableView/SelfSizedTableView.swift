//
//  SelfSizedTableView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/02.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
