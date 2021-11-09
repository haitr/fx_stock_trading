//
//  BaseCollectionViewCell.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/17.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    class var CellId: String {
        return "BaseCell"
    }
    
    lazy var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        setupAutoLayout()
    }
    
    func setupLayout() {
        
    }
    
    func setupAutoLayout() {
        
    }
}
