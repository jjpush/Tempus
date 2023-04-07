//
//  TimerStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import Foundation

import RxSwift

/// Start Timer used by TimerModel
final class TimerStartUseCase {
    private var time: Time {
        didSet {
            timeObservable.onNext(time)
        }
    }
    private let timeObservable: PublishSubject<Time> = .init()
    private var timer: Timer?
    private let originTime: Time
    
    init(model: TimerModel) {
        self.originTime = Time(second: model.wasteTime)
        self.time = originTime
    }
    
    private func flowSecond(second: Double) {
        time.flow(second: second)
    }
    
    func isTimerOver() -> Bool {
        if time.totalSecond == 0 {
            return true
        } else {
            return false
        }
    }
}

extension TimerStartUseCase: ModeInfo {
    var type: ModeType {
        return .timer
    }
    
    func fetchTimeObservable() -> PublishSubject<Time> {
        return timeObservable
    }
}

extension TimerStartUseCase: ModeController {
    func modeStart() {
        guard timer == nil else { return }

        let interval = 0.1
        
        time = originTime
        timer = Timer(timeInterval: interval, repeats: true, block: { timer in
            if self.time.totalSecond == 0 {
                self.time = self.originTime
            } else {
                self.flowSecond(second: interval)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    func modeStop() {
        timer?.invalidate()
        timer = nil
    }
}
