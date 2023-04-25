//
//  ClockViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/23.
//

import Foundation

import RxSwift

final class ClockViewModel {
    // MARK: - Input
    struct Input {
        let modeStartEvent: PublishSubject<Void>
        let modeStopEvent: PublishSubject<Void>
    }
    
    // MARK: - Output
    struct Output {
        let modeStartUseCaseOutput: PublishSubject<ModeStartUseCase.Output>
    }
    
    var modeStartUseCase: ModeStartUseCase? {
        didSet {
            guard let modeStartUseCase else { return }
            
            let startUseCaseInput = ModeStartUseCase.Input(modeStartEvent: self.modeStartEvent,
                                                           modeStopEvent: self.modeStopEvent)
            let startUseCaseOutput = modeStartUseCase.transform(input: startUseCaseInput, disposeBag: self.disposeBag)
            
            self.modeStartUseCaseOutput.onNext(startUseCaseOutput)
        }
    }
    
    private var modeStartEvent: PublishSubject<Void> = .init()
    private var modeStopEvent: PublishSubject<Void> = .init()
    private var disposeBag: DisposeBag = .init()
    
    private let modeStartUseCaseOutput: PublishSubject<ModeStartUseCase.Output> = .init()
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(modeStartUseCaseOutput: modeStartUseCaseOutput)
        
        self.modeStartEvent = input.modeStartEvent
        self.modeStopEvent = input.modeStopEvent
        self.disposeBag = disposeBag
        
        return output
    }
}
