//
//  DailyInfoEditCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/18.
//

import UIKit

final class DailyInfoEditCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .dailyInfoEdit }
    
    private let navigationController: UINavigationController
    private let repository: DataManagerRepository
    
    private let dailyInfoEditViewController: DailyInfoEditViewController
    private let dailyInfoEditViewModel: DailyInfoEditViewModel
    
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var finishDelegate: DailyFinishDelegate?
    private weak var editReflectDelegate: EditReflectDelegate?
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: DailyModel,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         finishDelegate: DailyFinishDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.navigationController = navigationController
        self.repository = repository
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.finishDelegate = finishDelegate
        self.editReflectDelegate = editReflectDelegate
        self.dailyInfoEditViewModel = .init(originModel: originModel)
        self.dailyInfoEditViewController = .init(viewModel: dailyInfoEditViewModel)
    }
    
    func start() {
        dailyInfoEditViewModel.coordinator = self
        navigationController.pushViewController(dailyInfoEditViewController, animated: true)
    }
    
    func finish() {
        self.navigationController.popViewController(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func pushDailyTimeDurationEditViewController(originModel: DailyModel) {
        let dailyTimeDurationEditCoordinator = DailyTimeDurationEditCoordinator(navigationController: self.navigationController,
                                                                                repository: self.repository,
                                                                                finishDelegate: self,
                                                                                originModel: originModel,
                                                                                fetchRefreshDelegate: self.fetchRefreshDelegate,
                                                                                editReflectDelegate: self.editReflectDelegate)
        dailyTimeDurationEditCoordinator.start()
        self.childCoordinators.append(dailyTimeDurationEditCoordinator)
    }
}

extension DailyInfoEditCoordinator: DailyFinishDelegate {
    func completeFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        self.finishDelegate?.completeFinish(childCoordinator: self)
    }
}
