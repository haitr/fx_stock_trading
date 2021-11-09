//
//  ViewController.swift
//  test-asd
//
//  Created by Cy2code-Hai on 2020/03/03.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: BaseView {
    
    private lazy var ctn = UIStackView()
    private lazy var lgnCtn = UIStackView()
    private lazy var lgnLbl = UILabel() ~ "Login"
    private lazy var lgnTxt = UITextField()
    private lazy var pwdCtn = UIStackView()
    private lazy var pwdLbl = UILabel() ~ "Password"
    private lazy var pwdTxt = UITextField()
    private lazy var lgnBtn = UIButton() ~ "Login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginView: BaseProtocol {
    func setupLayout() {
        ctn ~> view
        ctn ~ {
            $0.spacing = 10
            $0.axis = .vertical
        }
        // Login
        lgnCtn ~ {
            $0.spacing = 10
        }
        lgnTxt ~ {
            $0.placeholder = "ID"
            $0.borderStyle = .line
        }
        [lgnLbl, lgnTxt] ~> lgnCtn
        lgnCtn ~> ctn
        
        // Password
        pwdCtn ~ {
            $0.spacing = 10
        }
        pwdTxt ~ {
            $0.placeholder = "Password"
            $0.borderStyle = .line
        }
        [pwdLbl, pwdTxt] ~> pwdCtn
        pwdCtn ~> ctn
        
        lgnBtn ~ {
            $0.backgroundColor = UIColor.black
        }
        lgnBtn ~> ctn
    }
    
    func setupAutoLayout() {
        lgnCtn <> {
            $0.width.equalTo(250)
        }
        lgnLbl ~ {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        lgnLbl <> {
            $0.width.equalTo(pwdLbl.snp.width)
        }
        pwdLbl ~ {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        lgnBtn <> {
            $0.height.equalTo(50)
        }
        ctn <> {
            $0.center.equalToSuperview()
        }
    }
    
}

