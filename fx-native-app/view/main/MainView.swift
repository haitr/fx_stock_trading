//
//  MonitorView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/06.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit

class MainView: BaseView {
    
    let DEFAULT = "test"
    
    struct TableHeaderInfo {
        var title: String
        var size: Float
    }
    
    enum TableHeader: Int, CaseIterable {
        case type       = 1
        case amount     = 2
        case profit     = 3
        case accumulate = 4
        case date       = 5
        
        func info() -> TableHeaderInfo {
            switch (self) {
            case .type       : return TableHeaderInfo(title: "Side", size: 0.1)
            case .amount     : return TableHeaderInfo(title: ""    , size: 0.1)
            case .profit     : return TableHeaderInfo(title: "손익" , size: 0.1)
            case .accumulate : return TableHeaderInfo(title: "누적" , size: 0.1)
            case .date       : return TableHeaderInfo(title: "시간" , size: 0.1)
            }
        }
    }
    
    private lazy var scrollWrp            = UIScrollView()
    private lazy var ctn                  = UIView()
    
    // Chart
    private lazy var chartBlk             = UIStackView(translate: false)
    /// Chart bar
    private lazy var chartBar             = UIView()
    lazy var chartTypeSeg                 = Segment()
    var timeSel          : SelectButton!
    /// Actual chart
    lazy var chart                        = ChartContainer()
    
    // NavigationBar
    private lazy var navigationBlk        = UIView()
    lazy var chartDataTitleLbl            = UILabel() ~ DEFAULT
    private var titleImg : UIImageView!
    var accSel           : SelectButton!
    var chartDataSel     : SelectButton!
    
    // Setting
    private lazy var settingBlk           = UIView()
    private lazy var settingLbl           = UILabel() ~ "자동매매설정"
    lazy var settingBtn                   = RxRightIconButton()
    private lazy var settingWrp           = StackView()
    private lazy var keepSellWrp          = UIStackView(translate: false)
    /// Keep setting
    private lazy var keepWrp              = UIView()
    private lazy var keepTtlLbl           = UILabel() ~ "익절"
    lazy var keepLbl                      = UILabel() ~ DEFAULT
    lazy var keepDetailLbl                = UILabel() ~ DEFAULT
    /// Sell setting
    private lazy var sellWrp              = UIView()
    private lazy var sellTtlLbl           = UILabel() ~ "손절"
    lazy var sellLbl                      = UILabel() ~ DEFAULT
    lazy var sellDetailLbl                = UILabel() ~ DEFAULT
    /// Clear date setting
    private lazy var clearWrp             = StackView()
    private lazy var clearDateTtlLbl      = UILabel() ~ "미청산 처리"
    lazy var clearDateLbl                 = UILabel() ~ DEFAULT
    /// Total sell
    private lazy var orderQuantityWrp     = StackView()
    private lazy var orderQuantityTtlLbl  = UILabel() ~ "주문수량"
    lazy var orderQuantityLbl             = UILabel() ~ "0"
    
    // Table
    private lazy var tableBlk             = UIView()
    private lazy var tableTtlLbl          = UILabel() ~ "자동매매기록"
    lazy var tableDateLbl                 = UILabel() ~ "2020-03-06"
    /// Actual table
    lazy var tableCtn                     = UIView()
    /// Header
    private lazy var tableHeader          = UIStackView(translate: false)
    /// Table
    lazy var historyTbl                   = SelfSizedTableView()
    
    // Bottom bar
    private lazy var btmBarWrp            = StackView()
    lazy var leftBtn                      = UIButton()
    lazy var autoUpdateBtn                = RxStatefulButton()
    lazy var orderBookBtn                 = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide provided navigation bar
        self.navigationController?.navigationBar.isHidden = true
        // Enable swipe back gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

//MARK: - Navigation bar
extension MainView {
    private func styleNavigationBar() {
        // title
        titleImg = UIImageView()
        titleImg ~ {
            $0.image = UIImage(named: "logo_white")
            $0.contentMode = .scaleAspectFit
        }
        // left
        chartDataSel = SelectButton(of: self)
        chartDataSel ~ {
            $0.rx.font.onNext(NotoSans.Regular.size(14))
            $0.rx.color.onNext(Theme.iceBlue)
        }
        chartDataTitleLbl ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        // right
        accSel = SelectButton(of: self)
        accSel ~ {
            $0.rx.font.onNext(NotoSans.Regular.size(14))
            $0.rx.color.onNext(Theme.iceBlue)
        }
        //
        [titleImg, chartDataTitleLbl, accSel, chartDataSel] ~> navigationBlk
        navigationBlk ~> view
    }
    
    private func placeNavigationBar() {
        navigationBlk ~ {
            $0.preservesSuperviewLayoutMargins = true
        }
        navigationBlk <> {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(Theme.statusBarHeight(view.window) + Theme.navigationBarHeight)
        }
        titleImg <> {
            $0.height.equalTo(25)
            $0.topMargin.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        accSel <> {
            $0.rightMargin.equalToSuperview()
            $0.centerY.equalTo(titleImg.snp.centerY)
        }
        chartDataSel <> {
            $0.leftMargin.equalToSuperview()
            $0.centerY.equalTo(titleImg.snp.centerY)
        }
        chartDataTitleLbl <> {
            $0.left.equalTo(chartDataSel.snp.left)
            $0.top.equalTo(chartDataSel.snp.bottom)
        }
    }
}

//MARK: - Scroll container
extension MainView {
    private func styleScrollContainer() {
        scrollWrp ~ {
            $0.showsVerticalScrollIndicator = false
        }
        scrollWrp ~> view
        ctn ~> scrollWrp
    }
    
    private func placeScrollContainer() {
        [scrollWrp, ctn] ~ {
            $0.preservesSuperviewLayoutMargins = true
        }
        scrollWrp <> {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigationBlk.snp.bottom).offset(8)
        }
        ctn <> {
            // trick with UIScrollView and Auto Layout
            $0.left.top.right.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            // end trick
        }
        // Make sure that first & last view should bind to superview
        if let view = ctn.subviews.first {
            view <> {
                $0.top.equalToSuperview()
            }
        }
        if let view = ctn.subviews.last {
            view <> {
                $0.bottom.equalToSuperview()
            }
        }
    }
}

//MARK: - Chart
extension MainView {
    private func styleChart() {
        chartBar ~ {
            $0.backgroundColor = Theme.darkFive
        }
        chart ~ {
            $0.color = Theme.iceBlue
        }
        chartBlk ~ {
            $0.spacing = 0
            $0.axis = .vertical
        }
        timeSel = SelectButton(of: self)
        timeSel ~ {
            $0.rx.font.onNext(NotoSans.Regular.size(14))
            $0.rx.color.onNext(Theme.iceBlue)
        }
        //
        chartTypeSeg ~ {
            $0.rx.activeColor.onNext(Theme.cornflowerThree)
            $0.rx.inactiveColor.onNext(Theme.iceBlue)
            $0.rx.activeFont.onNext(NotoSans.Bold.size(14))
            $0.rx.inactiveFont.onNext(NotoSans.Regular.size(14))
        }
        //
        [timeSel, chartTypeSeg] ~> chartBar
        [chartBar, chart] ~> chartBlk
        chartBlk ~> ctn
    }
    
    private func placeChart() {
        [chartBlk, chartBar] ~ {
            $0.preservesSuperviewLayoutMargins = true
        }
        chartBlk <> {
            $0.left.right.equalToSuperview()
        }
        chartBar <> {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(32)
        }
        timeSel <> {
            $0.leftMargin.centerY.equalToSuperview()
        }
        chartTypeSeg <> {
            $0.left.equalTo(timeSel.snp.right).offset(20)
            $0.centerY.equalTo(timeSel.snp.centerY)
        }
        chart <> {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    private func bindChart() {
        //TEST
        chartTypeSeg.rx.data.onNext([
            SegmentButtonInfo(key: "idk", title: "CME"),
            SegmentButtonInfo(key: "idk2", title: "CME2")
        ])
        
        MockRedisService
            .shared
            .monitor(url: nil)
            .bind(to: chart.rxData)
            .disposed(by: disposeBag)
    }
}

//MARK: - Setting
extension MainView {
    private func addKeepSetting() {
        keepWrp ~ {
            $0.backgroundColor = Theme.darkSix
        }
        keepTtlLbl ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Medium.size(14)
        }
        keepLbl ~ {
            $0.textColor = Theme.iceBlue
            $0.font = NotoSans.Medium.size(14)
        }
        keepDetailLbl ~ {
            $0.textColor = Theme.yellowOrange
            $0.font = NotoSans.Regular.size(12)
        }
        [keepTtlLbl, keepLbl, keepDetailLbl] ~> keepWrp
        keepWrp ~> keepSellWrp
    }
    
    private func addSellSetting() {
        sellWrp ~ {
            $0.backgroundColor = Theme.darkSix
        }
        sellTtlLbl ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Medium.size(14)
        }
        sellLbl ~ {
            $0.textColor = Theme.iceBlue
            $0.font = NotoSans.Medium.size(14)
        }
        sellDetailLbl ~ {
            $0.textColor = Theme.yellowOrange
            $0.font = NotoSans.Regular.size(12)
        }
        [sellTtlLbl, sellLbl, sellDetailLbl] ~> sellWrp
        sellWrp ~> keepSellWrp
    }
    
    private func addClearDateSetting() {
        clearWrp ~ {
            $0.backgroundColor = Theme.darkSix
            $0.placement = .centerY
            $0.stack.axis = .vertical
            $0.stack.spacing = 0
        }
        // Because those items gonna equal width with co-responding labels
        // so they need to set textAlignment
        clearDateTtlLbl ~ {
            $0.textAlignment = .center
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Medium.size(14)
        }
        clearDateLbl ~ {
            $0.textColor = Theme.iceBlue
            $0.font = NotoSans.Regular.size(14)
            $0.textAlignment = .center
        }
        [clearDateTtlLbl, clearDateLbl] ~> clearWrp
    }
    
    private func addOrderQuantitySetting() {
        orderQuantityWrp ~ {
            $0.backgroundColor = Theme.darkSix
            $0.stack.axis = .vertical
            $0.stack.spacing = 0
            $0.placement = .centerY
        }
        // Because those items gonna equal width with co-responding labels
        // so they need to set textAlignment
        orderQuantityTtlLbl ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Medium.size(14)
            $0.textAlignment = .center
        }
        orderQuantityLbl ~ {
            $0.font = NotoSans.Bold.size(30)
            $0.textColor = Theme.yellowOrange
            $0.textAlignment = .center
        }
        [orderQuantityTtlLbl, orderQuantityLbl] ~> orderQuantityWrp
    }
    
    private func styleSetting() {
        settingBlk ~> ctn
        settingLbl ~ {
            $0.textColor = Theme.iceBlue
            $0.font = NotoSans.Medium.size(14)
        }
        settingBtn ~ {
            $0.rx.text.onNext("설정변경")
            $0.rx.font.onNext(NotoSans.Regular.size(14))
            $0.rx.color.onNext(Theme.blueGreyTwo)
            $0.rx.image.onNext(UIImage(named: "iconSettingOff"))
        }
        settingWrp ~ {
            $0.backgroundColor = Theme.white5
            $0.cornerRadius = 6
            $0.clipsToBounds = true
            $0.stack.axis = .horizontal
            $0.stack.distribution = .equalSpacing
        }
        [settingLbl, settingWrp, settingBtn] ~> settingBlk
        keepSellWrp ~ {
            $0.axis = .vertical
            $0.spacing = 1
        }
        [keepSellWrp, clearWrp, orderQuantityWrp] ~> settingWrp
        addKeepSetting()
        addSellSetting()
        addClearDateSetting()
        addOrderQuantitySetting()
    }
    
    private func placeKeepSetting() {
        keepWrp ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        keepWrp <> {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(sellWrp)
        }
        keepTtlLbl <> {
            $0.leftMargin.centerY.equalToSuperview()
        }
        [keepLbl, keepDetailLbl] <> {
            $0.centerY.equalTo(keepTtlLbl)
        }
        keepLbl <> {
            $0.left.equalTo(keepTtlLbl.snp.right).offset(10)
        }
        keepDetailLbl <> {
            $0.left.equalTo(keepLbl.snp.right).offset(10)
            $0.rightMargin.equalToSuperview()
        }
    }
    
    private func placeSellSetting() {
        sellWrp ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        sellWrp <> {
            $0.left.right.equalToSuperview()
        }
        sellTtlLbl <> {
            $0.leftMargin.centerY.equalToSuperview()
        }
        [sellLbl, sellDetailLbl] <> {
            $0.centerY.equalTo(sellTtlLbl)
        }
        sellLbl <> {
            $0.left.equalTo(sellTtlLbl.snp.right).offset(10)
        }
        sellDetailLbl <> {
            $0.left.equalTo(sellLbl.snp.right).offset(10)
            $0.rightMargin.equalToSuperview()
        }
    }
    
    private func placeClearDateSetting() {
        clearWrp ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        clearWrp <> {
            $0.top.bottom.equalToSuperview()
        }
        clearDateTtlLbl <> {
            $0.width.equalTo(clearDateLbl)
        }
    }
    
    private func placeOrderQuantitySetting() {
        orderQuantityWrp ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        orderQuantityWrp <> {
            $0.top.bottom.equalToSuperview()
        }
        orderQuantityTtlLbl <> {
            $0.width.equalTo(orderQuantityLbl)
        }
    }
    
    private func placeSetting() {
        settingBlk <> {
            $0.top.equalTo(chartBlk.snp.bottom).offset(16)
            $0.leftMargin.rightMargin.equalToSuperview()
        }
        settingLbl <> {
            $0.top.left.equalToSuperview()
        }
        settingBtn <> {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(settingLbl)
        }
        settingBtn.rx.size.onNext(CGSize(width: 22, height: 22))
        settingWrp <> {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(80)
            $0.top.equalTo(settingLbl.snp.bottom).offset(5)
        }
        keepSellWrp <> {
            $0.top.bottom.equalToSuperview()
        }
        placeKeepSetting()
        placeSellSetting()
        placeClearDateSetting()
        placeOrderQuantitySetting()
    }
}

//MARK: - Table
extension MainView {
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
        tableHeader ~> tableCtn
    }
    
    private func styleTable() {
        tableBlk ~> ctn
        tableTtlLbl ~ {
            $0.textColor = Theme.iceBlue
            $0.font = NotoSans.Medium.size(14)
        }
        tableDateLbl ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Regular.size(14)
        }
        tableCtn ~ {
            $0.backgroundColor = Theme.darkSix
            $0.cornerRadius = 6
            $0.clipsToBounds = true
        }
        addTableHeaderItems()
        historyTbl ~> tableCtn
        [tableTtlLbl, tableDateLbl, tableCtn] ~> tableBlk
    }
    
    private func placeTable() {
        tableBlk <> {
            $0.leftMargin.rightMargin.bottom.equalToSuperview()
            $0.top.equalTo(settingBlk.snp.bottom).offset(15)
        }
        tableTtlLbl <> {
            $0.top.left.equalToSuperview()
        }
        tableDateLbl <> {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(tableTtlLbl)
        }
        
        tableCtn ~ {
            $0.layoutMargins = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        }
        tableCtn <> {
            $0.top.equalTo(tableTtlLbl.snp.bottom).offset(7)
            $0.left.right.bottom.equalToSuperview()
        }
        tableHeader ~ {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        }
        tableHeader <> {
            $0.left.topMargin.right.equalToSuperview()
        }
        tableHeader.subviews
            .compactMap{ $0 as? UILabel }
            .forEach { v in
                guard let type = TableHeader(rawValue: v.tag) else {
                    return
                }
                v <> {
                    $0.width.equalToSuperview().multipliedBy(type.info().size)
                }
            }
        historyTbl <> {
            $0.top.equalTo(tableHeader.snp.bottom).offset(18)
            $0.left.bottomMargin.right.equalToSuperview()
        }
    }
    
    private func bindTable() {
        
    }
}

//MARK: - Bottom bar
extension MainView {
    private func styleBottomBar() {
        btmBarWrp ~ {
            $0.backgroundColor = Theme.darkSix
            $0.stack.axis = .horizontal
            $0.stack.spacing = 15
        }
        leftBtn ~ {
            $0.setImage(UIImage(named: "iconMenuW"), for: .normal)
        }
        orderBookBtn ~ {
            $0.setImage(UIImage(named: "iconGraphW"), for: .normal)
        }
        autoUpdateBtn ~ {
            $0.cornerRadius = 6
            $0.borderColor(Theme.cornflowerThree)
            $0.borderWidth(1)
            //
            $0.setTitle("자동매매중지", for: .normal)
            $0.setBackgroundColor(Theme.clear, for: .normal)
            $0.setTitleColor(Theme.cornflowerThree, for: .normal)
            //
            $0.setTitle("자동매매시작", for: .selected)
            $0.setBackgroundColor(Theme.dodgerBlue, for: .selected)
            $0.setTitleColor(Theme.iceBlue, for: .selected)
        }
        [leftBtn, autoUpdateBtn, orderBookBtn] ~> btmBarWrp
        btmBarWrp ~> view
    }
    
    private func placeBottomBar() {
        btmBarWrp ~ {
            $0.preservesSuperviewLayoutMargins = true
        }
        btmBarWrp <> {
            $0.bottomMargin.left.right.equalToSuperview()
        }
        leftBtn <> {
            $0.top.bottom.equalToSuperview()
            $0.size.equalTo(46)
        }
        orderBookBtn <> {
            $0.top.bottom.equalToSuperview()
            $0.size.equalTo(46)
        }
        
    }
}

//MARK: - Combine all together
extension MainView: BaseProtocol {
    func bind() {
        bindChart()
        bindTable()
    }
    
    func setupLayout() {
        view ~ {
            $0.backgroundColor = Theme.darkThree
        }
        styleNavigationBar()
        styleScrollContainer()
        styleChart()
        styleSetting()
        styleTable()
        styleBottomBar()
    }
    
    func setupAutoLayout() {
        view ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        placeNavigationBar()
        placeChart()
        placeScrollContainer()
        placeSetting()
        placeTable()
        placeBottomBar()
    }
}
