//
//  ClockViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/19.
//

import UIKit

import SSBouncyButton
import RxSwift
import SnapKit

class ClockViewController: UIViewController {
    private let startButton: SSBouncyButton = {
        let button = SSBouncyButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작", for: .normal)
        button.setTitle("중지", for: .selected)
        button.tintColor = .systemBlue
        
        return button
    }()
    
//    private let stopButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("중지", for: .normal)
//        button.setTitleColor(UIColor(displayP3Red: 0, green: 100, blue: 100, alpha: 1), for: .normal)
//
//        return button
//    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let countDownTimerView: CountDownTimerView = .init()
    
    private let startEvent: PublishSubject<Void> = .init()
    private let stopEvent: PublishSubject<Void> = .init()
    private let disposeBag: DisposeBag = .init()
    var viewModel: ClockViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelfView()
        configureUI()
        bindViewModel()
        
        let originModel = BlockModel(id: UUID(), title: "43", divideCount: 4)
        let startUseCase = BlockStartUseCase(originModel: originModel)
        
        viewModel?.modeStartUseCase = startUseCase
        
        startEvent.onNext(())
    }
}

// MARK: - ConfigureUI
private extension ClockViewController {
    func configureSelfView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureUI() {
        // 시계 뷰
        configureTimerView()
        
        // 시작버튼
        configureButtonStackView()
        configureStartButton()
    }
    
    func configureTimerView() {
        self.view.addSubview(countDownTimerView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        countDownTimerView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            
            make.height.equalTo(countDownTimerView.snp.width)
            make.top.equalTo(safeArea.snp.top).inset(self.view.bounds.height * 0.05)
        }
    }
    
    func configureButtonStackView() {
        self.view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(startButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(countDownTimerView.snp.bottom).offset(30)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
    }
    
    func configureStartButton() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        startButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    @objc func startButtonTapped() {
        startButton.isSelected = !startButton.isSelected
    }
}

// MARK: - BindViewModel
private extension ClockViewController {
    func bindViewModel() {
        let input = ClockViewModel.Input(modeStartEvent: startEvent,
                                         modeStopEvent: stopEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            #if DEBUG
            print(#file, #function, "viewModel missed")
            #endif
            return
        }
        
        output.modeStartUseCaseOutput
            .subscribe(onNext: { [weak self] output in
                guard let self else { return }
                
                output.remainTime.subscribe(onNext: { time in
                    // 받은 time을 뷰에다 넣기
                    print(time)
                    self.countDownTimerView.setTime(time)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}
