//
//  ChartContainer.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/10.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

fileprivate let CELL_WIDTH = 40.0

class ChartContainer: BaseComponent {
    
    // Views
    private lazy var axisX = AxisX(cellWidth: CELL_WIDTH, step: 5)
    private lazy var gridX = GridX(cellWidth: CELL_WIDTH, step: 10)
    private lazy var lineChartGridY = GridY(step: 5)
    lazy var chart = GradientLineChart(cellWidth: CELL_WIDTH)
    lazy var barChart = BarChart(cellWidth: CELL_WIDTH)
    lazy var fullscreenBtn = UIButton() ~ ""
    
    // Rx things
    lazy var rxData = BehaviorSubject<[Double]>(value: [])
    private lazy var rxScale = BehaviorSubject<Double>(value: 0.4)
    
    // Properties
    public var color = UIColor.white
}

extension ChartContainer: BaseProtocol {
    func bind() {
        //
        bindData()
        //
        pinchToZoom()
    }
    func bindData() {
        rxData
            .bind(to: chart.rxData, barChart.rxData, axisX.rxData, gridX.rxData)
            .disposed(by: self.disposeBag)
    }
    
    func pinchToZoom() {
        let pinch = self.rx.pinchGesture().share()
        let pinchBegan = pinch.when(.began).map { _ in try self.rxScale.value() }
        let pinchChanged = pinch.when(.changed).asScale()
        Observable
            .combineLatest(pinchBegan, pinchChanged)
            .map { $0.0 * Double($0.1.scale) }
            .bind(to: self.rxScale)
            .disposed(by: disposeBag)
        //
        self.rxScale
            .bind(to: self.chart.rxScale, self.barChart.rxScale, self.axisX.rxScale, self.gridX.rxScale)
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        //
        self ~ {
            $0.backgroundColor = Theme.darkTwo
            // Allow simultaneously scroll charts
            $0.addGestureRecognizer(chart.panGestureRecognizer)
            $0.addGestureRecognizer(barChart.panGestureRecognizer)
            $0.addGestureRecognizer(axisX.panGestureRecognizer)
            $0.addGestureRecognizer(gridX.panGestureRecognizer)
        }
        //
        [chart, lineChartGridY, barChart, axisX, gridX] ~ {
            $0.backgroundColor = UIColor.clear
        }
        //
        fullscreenBtn ~ {
            $0.tintColor = UIColor.white
            $0.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            $0.setBackgroundImage(UIImage(systemName: "square.and.arrow.down"), for: .selected)
        }
        //
        [gridX, lineChartGridY, chart, barChart, axisX] ~> self
        //
    }
    
    func setupAutoLayout() {
        chart <> {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()//.offset(-50)
        }
        lineChartGridY <> {
            $0.edges.equalTo(chart)
        }
        barChart <> {
            $0.top.equalTo(chart.snp.bottom).offset(8)
            $0.left.equalTo(chart.snp.left)
            $0.right.equalTo(chart.snp.right)
            $0.height.equalTo(50)
        }
        gridX <> {
            $0.top.equalTo(chart.snp.top)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(axisX.snp.top)
        }
        axisX <> {
            $0.top.equalTo(barChart.snp.bottom).offset(2)
            $0.left.equalTo(chart.snp.left)
            $0.right.equalTo(chart.snp.right)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}

extension BarChart: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Do not allow to scroll UIScrollView and Chart simultaneously
        return (otherGestureRecognizer.view.self is ChartContainer)
    }
}

extension GradientLineChart: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Do not allow to scroll UIScrollView and Chart simultaneously
        return (otherGestureRecognizer.view.self is ChartContainer)
    }
}

extension AxisX: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Do not allow to scroll UIScrollView and Chart simultaneously
        return (otherGestureRecognizer.view.self is ChartContainer)
    }
}
