//
//  TimerStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import Foundation

import RxSwift
import UserNotifications

final class TimerStartUseCase: ModeStartUseCase {
    private var remainTime: Time {
        didSet {
            timeObservable.onNext(remainTime)
        }
    }
    private var modeState: ModeState {
        didSet {
            modeStateObservable.onNext(modeState)
        }
    }
    
    private let timeObservable: PublishSubject<Time> = .init()
    private let modeStateObservable: PublishSubject<ModeState> = .init()
    private let entireRunningTime: PublishSubject<Double> = .init()
    private let disposeBag: DisposeBag = .init()
    private var timer: Timer?
    private let originModel: TimerModel
    
    init(originModel: TimerModel) {
        self.originModel = originModel
        self.remainTime = Time(second: originModel.wasteTime)
        self.modeState = .focusTime
    }
    
    override func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(remainTime: timeObservable,
                            modeState: modeStateObservable,
                            entireRunningTime: entireRunningTime)
        
        bindModeStartEvent(input.modeStartEvent, disposeBag: disposeBag)
        bindModeStopEvent(input.modeStopEvent, disposeBag: disposeBag)

        return output
    }
}

private extension TimerStartUseCase {
    func bindModeStartEvent(_ modeStartEvent: Observable<Void>, disposeBag: DisposeBag) {
        modeStartEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modeStart()
            }).disposed(by: disposeBag)
    }
    
    func bindModeStopEvent(_ modeStopEvent: Observable<Void>, disposeBag: DisposeBag) {
        modeStopEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modeStop()
            }).disposed(by: disposeBag)
    }
    
    func modeStart() {
        guard timer == nil else { return }

        enrollNotification(originModel.wasteTime)
        
        let interval = 0.1
        self.modeState = .focusTime
        entireRunningTime.onNext(originModel.wasteTime)
        remainTime = Time(second: originModel.wasteTime)
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            self.remainTime.flow(second: interval)
            
            if self.remainTime.totalSecond <= 0 {
                self.remainTime = Time(second: self.originModel.wasteTime)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    func modeStop() {
        timer?.invalidate()
        timer = nil
    }
}
