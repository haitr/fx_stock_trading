//
//  OrderBookView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderBookView: BaseView {
    
    struct TableHeaderInfo {
        var title: String
        var size: Float
    }
    
    enum TableHeader: Int, CaseIterable {
        case count  = 1
        case amount = 2
        
        func info() -> TableHeaderInfo {
            switch (self) {
            case .count : return TableHeaderInfo(title: "Count", size: 0.5)
            case .amount: return TableHeaderInfo(title: "Amount", size: 0.5)
            }
        }
    }
    
    lazy var backdrop            = UIButton() ~ ""
    private lazy var ctn         = UIView()
    
    private lazy var ttl         = UILabel() ~ "Order Book"
    private lazy var separator   = UIView()
    private lazy var tableHeader = UIStackView(translate : false)
    lazy var table               = UITableView()
}

// MARK: - Container
extension OrderBookView {
    private func styleContainer() {
        backdrop ~ {
            $0.backgroundColor = Theme.darkTwoTwo64
        }
        backdrop ~> view
        ctn ~ {
            $0.backgroundColor = Theme.charcoalGrey
        }
        ctn ~> view
    }
    
    private func placeContainer() {
        backdrop <> {
            $0.edges.equalToSuperview()
        }
        ctn ~ {
            $0.preservesSuperviewLayoutMargins = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        }
        ctn <> {
            $0.top.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            $0.width.equalTo(195)
        }
    }
}

// MARK: - Content
extension OrderBookView {
    private func styleContent() {
        ttl ~ {
            $0.textColor = Theme.cornflowerThree
            $0.font = NotoSans.Medium.size(16)
        }
        separator ~ {
            $0.backgroundColor = Theme.white5
        }
        
        addTableHeaderItems()
        
        [ttl, separator] ~> ctn
    }
    
    private func placeContent() {
        ttl <> {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ctn.safeAreaLayoutGuide.snp.topMargin)
        }
        separator <> {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(ttl.snp.bottom).offset(8)
            $0.height.equalTo(1)
        }
        tableHeader <> {
            $0.top.equalTo(separator.snp.bottom).offset(10)
            $0.leftMargin.rightMargin.equalToSuperview()
        }
    }
    
    private func bindContent() {
        
    }
    
    private func addTableHeaderItems() {
        tableHeader ~ {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        let headerItems: [UILabel] = TableHeader.allCases.map { type in
            let label = UILabel() ~ type.info().title
            label ~ {
                $0.textColor = Theme.blueGreyTwo
                $0.font = NotoSans.Regular.size(14)
                $0.tag = type.rawValue
            }
            return label
        }
        if let last = headerItems.last {
            last.textAlignment = .right
        }
        headerItems ~> tableHeader
        tableHeader ~> ctn
    }
    
}

// MARK: - All together
extension OrderBookView: BaseProtocol {
    func bind() {
        bindContent()
    }
    
    func setupLayout() {
        view ~ {
            $0.backgroundColor = UIColor.clear
        }
        styleContainer()
        styleContent()
    }
    
    func setupAutoLayout() {
        placeContainer()
        placeContent()
    }
}

extension OrderBookView: BackDropViewProtocol {
    var backdropView: UIView {
        return backdrop
    }
    
    var mainView: UIView {
        return ctn
    }
}
