//
//  BaseView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/06.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift

class BaseView: UIViewController {

    lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let c = self as? BaseProtocol {
            c.setupLayout()
            c.bind()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let c = self as? BaseProtocol {
            c.setupAutoLayout()
        }
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        if let c = self as? BaseProtocol {
//            c.setupAutoLayout()
//        }
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBar
    }
}
