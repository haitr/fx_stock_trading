//
//  SettingView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/08.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SettingView: BaseView {
    let DEFAULT = "test"
    
    lazy var backdrop                  = UIButton() ~ ""
    private lazy var ctn               = UIView()
    
    private lazy var titleLbl          = UILabel() ~ "자동매매설정"
    lazy var closeBtn                  = UIButton(type: .custom)
    lazy var settingSeg                = Segment()
    
    private lazy var keepSellWrp       = StackView()
    private lazy var keepLbl           = UILabel() ~ "익절조건"
    private lazy var keepCtn           = UIStackView(translate: false)
    lazy var keepSystemLbl             = UILabel() ~ DEFAULT
    lazy var keepBtn                   = RxRightIconButton()
    
    private lazy var sellLbl           = UILabel() ~ "손절조건"
    private lazy var sellCtn           = UIStackView(translate: false)
    lazy var sellSystemLbl             = UILabel() ~ DEFAULT
    lazy var sellBtn                   = RxRightIconButton()
    
    private lazy var quantityWrp       = StackView()
    private lazy var quantityTtlCtn    = UIStackView(translate: false)
    private lazy var quantityTtlLbl    = UILabel() ~ "주문수량"
    private lazy var maxQuantityLbl    = UILabel() ~ DEFAULT
    
    lazy var quantity                  = UILabel() ~ DEFAULT
    private lazy var stepper           = StackView()
    lazy var stepDownBtn               = UIButton(type: .custom)
    lazy var stepUpBtn                 = UIButton(type: .custom)
    private var premadeCtn             = UIStackView(translate: false)
    lazy var clearBtn                  = UIButton(type: .custom) ~ "Clr"
    lazy var premadeOneBtn             = UIButton(type: .custom) ~ "1"
    lazy var premadeFiveBtn            = UIButton(type: .custom) ~ "5"
    lazy var premadeTenBtn             = UIButton(type: .custom) ~ "10"
    private lazy var notice            = UIStackView(translate: false)
    private lazy var noticeIv          = UIImageView(
        image: UIImage(systemName: "info.circle")
    )
    private lazy var noticeLbl         = UILabel() ~ "최대주문 한도가 입력수량보다 적은경우 자동매매가 중지됩니다."
    
    private lazy var dateWrp           = StackView()
    private lazy var dateTtlLbl        = UILabel() ~ "데이-트레이딩 종료시간"
    lazy var dateBtn                   = RxRightIconButton()
    
    private lazy var bottomSeparator   = UIView()
    lazy var confirmBtn                = UIButton(type: .custom) ~ "설정변경"
}

// MARK: - Separator
extension SettingView {
    private func addSeparator(below: UIView) {
        let sep = UIView()
        sep ~ {
            $0.backgroundColor = Theme.blueGrey12
        }
        sep ~> ctn
        sep <> {
            $0.top.equalTo(below.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.rightMargin.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Container
extension SettingView {
    private func styleContainer() {
        backdrop ~ {
            $0.backgroundColor = Theme.darkTwoTwo64
        }
        backdrop ~> view
        ctn ~ {
            $0.backgroundColor = Theme.charcoalGrey
            $0.cornerRadius = 6
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
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }
}

// MARK: - Title
extension SettingView {
    private func styleTitle() {
        titleLbl ~ {
            $0.textColor = Theme.iceBlue
            $0.font = NotoSans.Medium.size(18)
        }
        closeBtn ~ {
            $0.setImage(UIImage(named: "iconCancelOff"), for: .normal)
        }
        [titleLbl, closeBtn] ~> ctn
    }
    
    private func placeTitle() {
        titleLbl <> {
            $0.leftMargin.top.rightMargin.equalToSuperview()
            $0.height.equalTo(48)
        }
        closeBtn <> {
            $0.size.equalTo(48)
            $0.top.right.equalToSuperview()
        }
    }
}

// MARK: - Segment
extension SettingView {
    private func styleSeg() {
        settingSeg ~ {
            $0.spacing = 22
            $0.rx.activeColor.onNext(Theme.cornflowerThree)
            $0.rx.inactiveColor.onNext(Theme.blueGreyTwo)
            $0.rx.activeFont.onNext(NotoSans.Regular.size(16))
            $0.rx.inactiveFont.onNext(NotoSans.Regular.size(16))
        }
        settingSeg ~> ctn
    }
    
    private func placeSeg() {
        settingSeg <> {
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.leftMargin.equalToSuperview()
        }
        addSeparator(below: settingSeg)
    }
    
    private func bindSeg() {
        settingSeg.rx.data.onNext([
            SegmentButtonInfo(key: "basic", title: "기본형"),
            SegmentButtonInfo(key: "custom", title: "사용자설정")
        ])
        settingSeg.rx.selected.onNext("basic")
    }
}

// MARK: - Keep & Sell settings
extension SettingView {
    private func styleKeepSellSetting() {
        [keepSystemLbl, sellSystemLbl] ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Regular.size(12)
        }
        [keepBtn, sellBtn] ~ {
            $0.cornerRadius = 6
            $0.borderWidth(1)
            $0.borderColor(Theme.blueGrey)
            $0.rx.font.onNext(NotoSans.Medium.size(12))
            $0.rx.color.onNext(Theme.blueGreyTwo)
            $0.rx.image.onNext(UIImage(named: "iconDropdownOn02"))
        }
        [keepCtn, sellCtn] ~ {
            $0.axis = .vertical
            $0.spacing = 0
        }
        [keepSystemLbl, keepBtn] ~> keepCtn
        [sellSystemLbl, sellBtn] ~> sellCtn
    }
    
    private func styleKeepSell() {
        keepSellWrp ~> ctn
        keepSellWrp ~ {
            $0.stack.spacing = 10
            $0.stack.axis = .vertical
            $0.stack.setCustomSpacing(20, after: keepCtn)
        }
        [keepLbl, sellLbl] ~ {
            $0.textColor = Theme.lightBlueGrey
            $0.font = NotoSans.Medium.size(14)
        }
        styleKeepSellSetting()
        [keepLbl, keepCtn, sellLbl, sellCtn] ~> keepSellWrp
    }
    
    fileprivate func placeKeepSellSetting() {
        [keepCtn, sellCtn] <> {
            $0.left.right.equalToSuperview()
        }
        [keepBtn, sellBtn] ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        }
        [keepBtn, sellBtn] <> {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    private func placeKeepSell() {
        keepSellWrp ~ {
            $0.preservesSuperviewLayoutMargins = true
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
        keepSellWrp <> {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(settingSeg.snp.bottom)
        }
        placeKeepSellSetting()
        addSeparator(below: keepSellWrp)
    }
    
    private func bindKeepSell() {
        let state = settingSeg.rx.selected.share()
        state
            .map{ $0 == "basic" }
            .bind(to: keepBtn.rx.isHidden, sellBtn.rx.isHidden)
            .disposed(by: disposeBag)
        state
            .map{ $0 != "basic" }
            .bind(to: keepSystemLbl.rx.isHidden, sellSystemLbl.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: - Quantity
extension SettingView {
    private func styleQuantity() {
        quantityWrp ~ {
            $0.stack.axis = .vertical
            $0.stack.spacing = 10
        }
        
        quantityTtlCtn ~ {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        quantityTtlLbl ~ {
            $0.textColor = Theme.lightBlueGrey
            $0.font = NotoSans.Regular.size(14)
        }
        maxQuantityLbl ~ {
            $0.textColor = Theme.blueGreyTwo
            $0.font = NotoSans.Regular.size(12)
        }
        
        stepDownBtn ~ {
            $0.setImage(UIImage(named: "iconMinus"), for: .normal)
        }
        stepUpBtn ~ {
            $0.setImage(UIImage(named: "iconPlus"), for: .normal)
        }
        quantity ~ {
            $0.textColor = Theme.veryLightBlue
            $0.font = NotoSans.Regular.size(14)
            $0.textAlignment = .center
        }
        [stepDownBtn, quantity, stepUpBtn] ~ {
            $0.backgroundColor = Theme.charcoalGrey
        }
        stepper ~ {
            $0.backgroundColor = Theme.slateThree
            $0.cornerRadius = 6
            $0.borderWidth(1)
            $0.borderColor(Theme.slateThree)
            $0.stack.spacing = 1
            $0.stack.axis = .horizontal
        }
        
        premadeCtn ~ {
            $0.distribution = .fillEqually
            $0.spacing = 15
        }
        [clearBtn, premadeOneBtn, premadeFiveBtn, premadeTenBtn] ~ {
            $0.setTitleColor(Theme.blueGrey, for: .normal)
            $0.titleLabel?.font = NotoSans.Regular.size(12)
            $0.cornerRadius = 6
            $0.borderColor(Theme.blueGrey)
            $0.borderWidth(1)
        }
        
        notice ~ {
            $0.spacing = 6
            $0.axis = .horizontal
            $0.alignment = .center
        }
        noticeIv ~ {
            $0.tintColor = Theme.blueGrey
        }
        noticeLbl ~ {
            $0.font = NotoSans.Regular.size(12)
            $0.textColor = Theme.blueGrey
        }
        
        [quantityTtlLbl, maxQuantityLbl] ~> quantityTtlCtn
        [stepDownBtn, quantity, stepUpBtn] ~> stepper
        [clearBtn, premadeOneBtn, premadeFiveBtn, premadeTenBtn] ~> premadeCtn
        [noticeIv, noticeLbl] ~> notice
        [quantityTtlCtn, stepper, premadeCtn, notice] ~> quantityWrp
        quantityWrp ~> ctn
    }
    
    private func placeQuantity() {
        quantityWrp ~ {
            $0.preservesSuperviewLayoutMargins = true
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
        quantityWrp <> {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(keepSellWrp.snp.bottom)
        }
        
        quantityTtlCtn <> {
            $0.left.right.equalToSuperview()
        }
        maxQuantityLbl ~ {
            $0.snp.contentHuggingHorizontalPriority = 251
        }
        
        stepper ~ {
            $0.layoutMargins = UIEdgeInsets.zero
        }
        stepper <> {
            $0.height.equalTo(40)
        }
        [stepDownBtn, quantity, stepUpBtn] <> {
            $0.top.bottom.equalToSuperview()
        }
        [stepDownBtn, stepUpBtn] <> {
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        noticeIv <> {
            $0.size.equalTo(16)
        }
        
        addSeparator(below: quantityWrp)
    }
    
    private func bindQuantity() {
        
    }
}

// MARK: - Date
extension SettingView {
    private func styleDate() {
        dateWrp ~ {
            $0.stack.axis = .vertical
            $0.stack.spacing = 10
        }
        dateTtlLbl ~ {
            $0.font = NotoSans.Medium.size(14)
            $0.textColor = Theme.lightBlueGrey
        }
        dateBtn ~ {
            $0.cornerRadius = 6
            $0.borderWidth(1)
            $0.borderColor(Theme.blueGrey)
            $0.rx.font.onNext(NotoSans.Medium.size(12))
            $0.rx.color.onNext(Theme.blueGreyTwo)
            $0.rx.image.onNext(UIImage(named: "iconDropdownOn02"))
        }
        
        [dateTtlLbl, dateBtn] ~> dateWrp
        dateWrp ~> ctn
    }
    
    private func placeDate() {
        dateBtn ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        }
        dateWrp ~ {
            $0.preservesSuperviewLayoutMargins = true
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
        dateWrp <> {
            $0.top.equalTo(quantityWrp.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        dateBtn <> {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    private func bindDate() {
        
    }
}

// MARK: - Confirm
extension SettingView {
    private func styleConfirm() {
        bottomSeparator ~ {
            $0.backgroundColor = Theme.blueGrey12
        }
        confirmBtn ~ {
            $0.titleLabel?.font = NotoSans.Regular.size(16)
            $0.setTitleColor(Theme.veryLightBlue, for: .normal)
        }
        [bottomSeparator, confirmBtn] ~> ctn
    }
    
    private func placeConfirm() {
        bottomSeparator <> {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(confirmBtn.snp.top)
        }
        confirmBtn <> {
            $0.height.equalTo(50)
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(dateWrp.snp.bottom)
        }
    }
}

// MARK: - All together
extension SettingView: BaseProtocol {
    func bind() {
        bindSeg()
        bindKeepSell()
        bindQuantity()
        bindDate()
    }
    
    func setupLayout() {
        view ~ {
            $0.backgroundColor = UIColor.clear
        }
        styleContainer()
        styleTitle()
        styleSeg()
        styleKeepSell()
        styleQuantity()
        styleDate()
        styleConfirm()
    }
    
    func setupAutoLayout() {
        placeContainer()
        placeTitle()
        placeSeg()
        placeKeepSell()
        placeQuantity()
        placeDate()
        placeConfirm()
    }
}

extension SettingView: BackDropViewProtocol {
    var backdropView: UIView {
        return backdrop
    }
    
    var mainView: UIView {
        return ctn
    }
}
