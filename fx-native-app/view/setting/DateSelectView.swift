//
//  DateSelectView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DateSelectView: BaseView {
    let DEFAULT = "test"
    
    lazy var backdrop    = UIButton() ~ ""
    private lazy var ctn = StackView()
    
    private lazy var selectCtn = StackView()
    private var defaultBtn = RxRadioButton()
    private var optionBtn = RxRadioButton()
    private let rx_group = PublishRelay<RxRadioButton>()
    
    private lazy var dateSelectCtn = StackView()
    private lazy var datePicker = UIDatePicker()
    
    private lazy var separator = UIView()
    
    private lazy var btnCtn = StackView()
    lazy var cancelBtn = UIButton() ~ "취소"
    lazy var confirmBtn = UIButton() ~ "확인"
}

// MARK: - Container
extension DateSelectView {
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
            $0.layoutMargins = UIEdgeInsets(top: 29, left: 0, bottom: 0, right: 0)
            $0.stack.axis = .vertical
            $0.stack.spacing = 20
            $0.clipsToBounds = true
        }
        ctn <> {
            $0.centerY.equalToSuperview()
            // somehow view.layoutMargin doesn't work
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
        }
    }
}

// MARK: - Content
extension DateSelectView {
    private func styleContent() {
        [defaultBtn, optionBtn] ~ {
            $0.rx.spacing.onNext(22)
            $0.rx.font.onNext(NotoSans.Light.size(14))
            $0.rx.size.onNext(CGSize(width: 24, height: 24))
        }
        defaultBtn ~ {
            $0.rx.text.onNext("당일마감시")
        }
        optionBtn ~ {
            $0.rx.text.onNext("청산 예약시간")
        }
        selectCtn ~ {
            $0.stack.axis = .vertical
            $0.stack.spacing = 20
        }
        datePicker ~ {
            $0.datePickerMode = .time
            $0.setValue(UIColor.white, forKeyPath: "textColor")
        }
        dateSelectCtn ~ {
            $0.backgroundColor = Theme.slateTwo39
        }
        [datePicker] ~> dateSelectCtn
        [defaultBtn, optionBtn] ~> selectCtn
        [selectCtn, dateSelectCtn] ~> ctn
        styleButtons()
    }
    
    private func styleButtons() {
        separator ~ {
            $0.backgroundColor = Theme.blueGrey12
        }
        cancelBtn ~ {
            $0.setTitleColor(Theme.blueGreyTwo, for: .normal)
            $0.titleLabel?.font = NotoSans.Light.size(16)
            $0.backgroundColor = Theme.charcoalGrey
        }
        confirmBtn ~ {
            $0.setTitleColor(Theme.cornflowerThree, for: .normal)
            $0.titleLabel?.font = NotoSans.Medium.size(16)
            $0.backgroundColor = Theme.charcoalGrey
        }
        btnCtn ~ {
            $0.backgroundColor = Theme.blueGrey12
            $0.stack.spacing = 1
            $0.stack.distribution = .fillEqually
        }
        [cancelBtn, confirmBtn] ~> btnCtn
        [separator, btnCtn] ~> ctn
    }
    
    private func placeContent() {
        selectCtn ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        }
        dateSelectCtn ~ {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
        dateSelectCtn <> {
            $0.left.right.equalToSuperview()
        }
        datePicker <> {
            $0.height.equalTo(200)
        }
        placeButtons()
    }
    
    private func placeButtons() {
        separator <> {
            $0.height.equalTo(1)
        }
        ctn ~ {
            $0.stack.setCustomSpacing(0, after: dateSelectCtn)
            $0.stack.setCustomSpacing(0, after: separator)
        }
        btnCtn ~ {
            $0.layoutMargins = UIEdgeInsets.zero
        }
        [cancelBtn, confirmBtn] <> {
            $0.height.equalTo(50)
        }
    }
    
    private func bindContent() {
        bindRadioBtn(defaultBtn, to: rx_group)
        bindRadioBtn(optionBtn, to: rx_group)
        rx_group
            .map{$0 != self.optionBtn}
            .bind(to: dateSelectCtn.rx.isHidden)
            .disposed(by: disposeBag)
        // retrieve from server or local storage
        rx_group.accept(defaultBtn)
    }
    
    private func bindRadioBtn(_ btn: RxRadioButton, to group: PublishRelay<RxRadioButton>) {
        btn.rx.tap
            .compactMap{$0 as? RxRadioButton}
            .bind(to: group)
            .disposed(by: disposeBag)
        group
            .distinctUntilChanged()
            .map{$0 == btn ? .selected : .unselected}
            .bind(to: btn.rx.state)
            .disposed(by: disposeBag)
    }
}

// MARK: - All together
extension DateSelectView: BaseProtocol {
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

extension DateSelectView: BackDropViewProtocol {
    var backdropView: UIView {
        return backdrop
    }
    
    var mainView: UIView {
        return ctn
    }
}
