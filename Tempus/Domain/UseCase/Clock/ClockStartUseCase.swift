//
//  ClockStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/12.
//

import Foundation

import RxSwift

final class ClockStartUseCase {
    struct Input {
        let modeStartEvent: Observable<Void>
        let modeStopEvent: Observable<Void>
    }
    
    struct Output {
        let remainTime: PublishSubject<Time>
        let modeState: PublishSubject<ModeState>
    }
    
    var modeControllerDelegate: ModeController?
    
    func bind(to input: Input) throws -> Output {
        guard let modeControllerDelegate else {
            throw ModeManageError.modeNotExist
        }
        
        let output = modeControllerDelegate.bind(to: input)
        
        return output
    }
}
