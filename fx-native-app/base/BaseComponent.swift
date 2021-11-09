//
//  BaseComponent.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/06.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift

protocol BaseProtocol {
    func setupLayout()
    func setupAutoLayout()
    func bind()
}

extension BaseProtocol {
    func bind() {
        //
    }
}

class BaseComponent: UIView {
    lazy var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError(#file + ":" + #function + " method must be overridden.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let c = self as? BaseProtocol {
            c.setupLayout()
            c.bind()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let c = self as? BaseProtocol {
            c.setupAutoLayout()
        }
    }
}
