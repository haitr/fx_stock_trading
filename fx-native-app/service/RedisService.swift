//
//  RedisService.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/09.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit
import RxSwift

protocol RedisProtocol {
    static var shared: RedisProtocol { get }
    func monitor(url: URL?) -> BehaviorSubject<[Double]>
}

//class RedisService: RedisProtocol {
//    static var shared: RedisProtocol = RedisService()
//
//    func monitor(url: URL?) -> BehaviorSubject<Float> {
//        return BehaviorSubject<Float>(value: 0)
//    }
//}

class MockRedisService: RedisProtocol {
    static var shared: RedisProtocol = MockRedisService()
    
    lazy var disposeBag = DisposeBag()
    lazy var rxData = BehaviorSubject<[Double]>(value: [])
    var data: ChartRawDataType = []
    
    func monitor(url: URL?) -> BehaviorSubject<[Double]> {
//        Observable<Int>
//            .timer(DispatchTimeInterval.seconds(0), period: DispatchTimeInterval.seconds(10), scheduler: MainScheduler.instance)
//            .subscribe { _ in
//                self.generate()
//            }
//            .disposed(by: disposeBag)
        self.generate()
        return rxData
    }
    
    private func generate() {
        let min: Double = 100.0
        let max: Double = 200.0
        let n = 100
        if (data.count == 0) {
            data = Array(0..<n).map { _ in .random(in: min..<max) }
        } else {
            data[2] = .random(in: min..<max)
        }
        rxData.onNext(data)
    }
}
