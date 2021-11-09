//
//  KeepSelectView.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/04/14.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class KeepSelectView: BaseView {
    let DEFAULT = "test"
    
    lazy var backdrop    = UIButton() ~ ""
    private lazy var ctn = StackView()
    
    private lazy var selectCtn = StackView()
    private lazy var titleLbl = UILabel() ~ "손절조건"
    private lazy var defaultBtn = RxRadioButton()
    private lazy var tickOptionBtn = RxRadioWithInputButton()
    private lazy var ratioOptionBtn = RxRadioWithInputButton()
    private let rx_group = PublishRelay<RxRadioButton>()
    
    private lazy var descriptionCtn = StackView()
    private lazy var descriptionLbl = UILabel() ~ DEFAULT
    
    private lazy var separator = UIView()
    
    private lazy var btnCtn = StackView()
    lazy var cancelBtn = UIButton() ~ "취소"
    lazy var confirmBtn = UIButton() ~ "확인"
}

// MARK: - Container
extension KeepSelectView {
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
extension KeepSelectView {
    
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
    
    private func styleDescription() {
        descriptionLbl ~ {
            $0.font = NotoSans.Regular.size(12)
        }
        descriptionCtn ~ {
            $0.backgroundColor = Theme.slateTwo39
        }
        descriptionLbl ~> descriptionCtn
        descriptionCtn ~> ctn
    }
    
    private func styleSelection() {
        [defaultBtn, tickOptionBtn, ratioOptionBtn] ~ {
            $0.rx.spacing.onNext(12)
            $0.rx.font.onNext(NotoSans.Light.size(14))
            $0.rx.size.onNext(CGSize(width: 24, height: 24))
        }
        [tickOptionBtn, ratioOptionBtn] ~ {
            $0.inputWidth = 41
            $0.textInput.font = NotoSans.Regular.size(14)
            $0.textInput.textColor = Theme.cloudyBlue
        }
        defaultBtn ~ {
            $0.rx.text.onNext("시스템익절")
        }
        tickOptionBtn ~ {
            $0.rx.text.onNext("TICK")
        }
        ratioOptionBtn ~ {
            $0.rx.text.onNext("%")
        }
        selectCtn ~ {
            $0.stack.axis = .vertical
            $0.stack.spacing = 20
        }
        titleLbl ~ {
            $0.textColor = Theme.veryLightBlue
            $0.font = NotoSans.Medium.size(16)
        }
        [titleLbl, defaultBtn, tickOptionBtn, ratioOptionBtn] ~> selectCtn
        selectCtn ~> ctn
    }
    
    private func styleContent() {
        styleSelection()
        styleDescription()
        styleButtons()
    }
    
    private func placeDescription() {
        ctn ~ {
            $0.stack.setCustomSpacing(0, after: descriptionCtn)
        }
        descriptionCtn ~ {
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 22, bottom: 20, right: 22)
        }
        descriptionCtn <> {
            $0.left.right.equalToSuperview()
        }
    }
    
    private func placeButtons() {
        separator <> {
            $0.height.equalTo(1)
        }
        ctn ~ {
            $0.stack.setCustomSpacing(0, after: separator)
        }
        btnCtn ~ {
            $0.layoutMargins = UIEdgeInsets.zero
        }
        [cancelBtn, confirmBtn] <> {
            $0.height.equalTo(50)
        }
    }
    
    private func placeContent() {
        selectCtn ~ {
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        }
        placeDescription()
        placeButtons()
    }
    
    private func bindContent() {
        bindRadioBtn(defaultBtn, to: rx_group)
        bindRadioBtn(tickOptionBtn, to: rx_group)
        bindRadioBtn(ratioOptionBtn, to: rx_group)
        // adapt text field's underline color
        rx_group
            .map{$0 == self.defaultBtn}
            .map{state in state ? Theme.slateFour : Theme.cloudyBlue}
            .subscribe {
                self.descriptionLbl.textColor = $0.element
            }
            .disposed(by: disposeBag)
        // retrieve from server or local storage
        rx_group.accept(defaultBtn)
    }
    
    private func bindRadioBtn(_ btn: RxRadioButton, to group: PublishRelay<RxRadioButton>) {
        let tap = btn.rx.tap.share()
        tap
            .compactMap{$0 as? RxRadioButton}
            .bind(to: group)
            .disposed(by: disposeBag)
        // Take over input cursor
        tap
            .subscribe {_ in
                UIApplication.shared.sendAction(
                    #selector(UIApplication.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil)
            }
            .disposed(by: disposeBag)
        tap
            .compactMap{$0 as? RxRadioWithInputButton}
            .subscribe {
                $0.element?.textInput.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        group
            .distinctUntilChanged()
            .map{$0 == btn ? .selected : .unselected}
            .bind(to: btn.rx.state)
            .disposed(by: disposeBag)
        // filter the text input
        if let radio = btn as? RxRadioWithInputButton {
            radio.rx.textInput.orEmpty
                .map {
                    // allow only digit
                    // allow only 2 input characters
                    let allowedCharset = CharacterSet.decimalDigits
                    return String($0.unicodeScalars.filter(allowedCharset.contains).prefix(2))
                }
                .bind(to: radio.rx.textInput)
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - All together
extension KeepSelectView: BaseProtocol {
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

extension KeepSelectView: BackDropViewProtocol {
    var backdropView: UIView {
        return backdrop
    }
    
    var mainView: UIView {
        return ctn
    }
}
