//
//  DailyTimeDurationEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/06.
//

import Foundation

import RxRelay
import RxSwift

final class DailyTimeDurationEditViewModel {
    struct Input {
        let startTime: Observable<Double>
        let repeatCount: Observable<Int>
        
        let backButtonTapEvent: Observable<Void>
        let completeButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isEditSuccess: PublishSubject<Bool>
    }
    
    private var startTime: Double?
    private var repeatCount: Int?
    
    private let editUseCase: DailyEditUseCase
    private var originModel: DailyModel
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var editReflectDelegate: EditReflectDelegate?
    
    private let completeButtonTapEvent: PublishSubject<DailyModel> = .init()
    
    init(originModel: DailyModel,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.originModel = originModel
        self.editUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.editReflectDelegate = editReflectDelegate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let editUseCaseInput = DailyEditUseCase.Input(modelEditEvent: self.completeButtonTapEvent)
        let editUseCaseOutput = editUseCase.transform(input: editUseCaseInput,
                                                      disposeBag: disposeBag)
        
        let output = Output(isEditSuccess: editUseCaseOutput.isEditSuccess)
        
        bindStartTime(input.startTime, disposeBag)
        bindRepeatCount(input.repeatCount, disposeBag)
        bindBackButtonTapEvent(input.backButtonTapEvent, disposeBag)
        bindCompleteButtonTapEvent(input.completeButtonTapEvent, disposeBag)
        
        return output
    }
}

private extension DailyTimeDurationEditViewModel {
    func bindStartTime(_ startTime: Observable<Double>, _ disposeBag: DisposeBag) {
        startTime
            .subscribe(onNext: { [weak self] startTime in
                guard let self else { return }
                self.startTime = startTime
            }).disposed(by: disposeBag)
    }
    
    func bindRepeatCount(_ repeatCount: Observable<Int>, _ disposeBag: DisposeBag) {
        repeatCount
            .subscribe(onNext: { [weak self] repeatCount in
                guard let self else { return }
                self.repeatCount = repeatCount
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteButtonTapEvent(_ completeButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        completeButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                
                if let startTime = self.startTime {
                    self.originModel.startTime = startTime
                }
                
                if let repeatCount = self.repeatCount {
                    self.originModel.repeatCount = repeatCount
                }
                
                self.completeButtonTapEvent.onNext(self.originModel)
            }).disposed(by: disposeBag)
    }
    
    func bindBackButtonTapEvent(_ backButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        backButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                
                // coordinator pop
            })
            .disposed(by: disposeBag)
    }
}
