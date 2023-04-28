//
//  BlockFetchUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import RxSwift

final class BlockFetchUseCase {
    struct Input {
        let modelFetchEvent: Observable<Void>
    }
    
    struct OutPut {
        let modelArrayObservable: PublishSubject<[BlockModel]> = .init()
    }
    
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> OutPut {
        let output = OutPut()
        
        input.modelFetchEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                do {
                    try self.execute { models in
                        output.modelArrayObservable.onNext(models)
                    }
                } catch {
//                    self.modelArrayObservable.onError(error)
                    return
                }
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension BlockFetchUseCase {
    func execute(_ completion: @escaping ([BlockModel]) -> Void) throws {
        let models = try repository.fetchAllBlockModel()
        completion(models)
    }
}
