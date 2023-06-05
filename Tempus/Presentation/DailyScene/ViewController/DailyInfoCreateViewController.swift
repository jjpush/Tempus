//
//  DailyInfoCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/04.
//

import UIKit

import RxSwift

class DailyInfoCreateViewController: UIViewController {

    private enum Constant {
        static let outerMargin: CGFloat = 30
    }
    
    private let cancelButton: UIBarButtonItem = .init(systemItem: .cancel)
    private let nextButton: UIBarButtonItem = .init()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        
        return textField
    }()
    
    private let TimeInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let focusTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let focusTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "집중시간"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let focusTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("선택", for: .normal)
        
        return button
    }()
    
    private let breakTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let breakTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "휴식시간"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let breakTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("선택", for: .normal)
        
        return button
    }()
    
    private weak var viewModel: DailyInfoEditViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private let modelTitleSubject: PublishSubject<String> = .init()
    private let modelFocusTimeSubject: PublishSubject<Double> = .init()
    private let modelBreakTimeSubject: PublishSubject<Double> = .init()
    private let nextButtonTappedEvent: PublishSubject<Void> = .init()
    private let cancelButtonTappedEvent: PublishSubject<Void> = .init()
    
    init(viewModel: DailyInfoEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureUI()
        bindViewModel()
    }
    
    private func makeWidthDividerView() -> UIView {
        let emptyView = UIView()
        
        emptyView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(1)
        }
        
        return emptyView
    }
}

// MARK: - ConfigureUI
private extension DailyInfoCreateViewController {
    func configureUI() {
        configureNavigationBar()
        configureTitleTextField()
        configureTimeInfoStackView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새로 만들기"
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = nextButton
        
//        cancelButton.target = self
//        cancelButton.action = #selector(cancelBarButtonTapped)
        
        nextButton.title = "다음"
        nextButton.target = self
        nextButton.action = #selector(nextBarButtonTapped)
    }
    
//    @objc func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
//        print("cancel Button tapped")
//    }
    
    @objc func nextBarButtonTapped(_ sender: UIBarButtonItem) {
        print("next Button tapped")
    }
    
    func configureTitleTextField() {
        self.view.addSubview(titleTextField)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.titleTextField.snp.makeConstraints { make in
            let inset = Constant.outerMargin
            
            make.leading.equalTo(safeArea.snp.leading).inset(inset)
            make.trailing.equalTo(safeArea.snp.trailing).inset(inset)
            make.top.equalTo(safeArea.snp.top).inset(inset * 2)
            make.height.equalTo(titleTextField.intrinsicContentSize.height)
        }
    }
    
    func configureTimeInfoStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(TimeInfoStackView)
        self.TimeInfoStackView.addArrangedSubview(focusTimeStackView)
        self.TimeInfoStackView.addArrangedSubview(breakTimeStackView)
        self.TimeInfoStackView.spacing = safeArea.layoutFrame.height * 0.08
        configureFocusTimeStackView()
        configureBreakTimeStackView()
        
        
        self.TimeInfoStackView.snp.makeConstraints { make in
            let inset = Constant.outerMargin
            
            make.leading.equalTo(safeArea.snp.leading).inset(inset)
            make.trailing.equalTo(safeArea.snp.trailing).inset(inset)
            
            make.top.equalTo(titleTextField.snp.bottom).offset(safeArea.layoutFrame.height * 0.1)
        }
    }
    
    func configureFocusTimeStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let leftDividerView = makeWidthDividerView()
        
        self.focusTimeStackView.addArrangedSubview(leftDividerView)
        self.focusTimeStackView.addArrangedSubview(focusTimeLabel)
        self.focusTimeStackView.addArrangedSubview(focusTimeButton)
        self.focusTimeStackView.addArrangedSubview(makeWidthDividerView())
        configureFocusTimeButton()
        
        self.focusTimeStackView.spacing = safeArea.layoutFrame.width * 0.1
        
        let stackWidthSize = self.view.frame.width - Constant.outerMargin * 2
        let allSpacing: CGFloat = 3 * self.focusTimeStackView.spacing
        let mainSize = focusTimeLabel.intrinsicContentSize.width + focusTimeButton.intrinsicContentSize.width + allSpacing
        let targetSize = (stackWidthSize - mainSize) / 2
        
        leftDividerView.snp.remakeConstraints { make in
            make.width.equalTo(targetSize)
        }
    }
    
    func configureFocusTimeButton() {
        self.focusTimeButton.snp.makeConstraints { make in
            make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width).multipliedBy(0.15)
        }
    }
    
    func configureBreakTimeStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let leftDividerView = makeWidthDividerView()
        
        self.breakTimeStackView.addArrangedSubview(leftDividerView)
        self.breakTimeStackView.addArrangedSubview(breakTimeLabel)
        self.breakTimeStackView.addArrangedSubview(breakTimeButton)
        self.breakTimeStackView.addArrangedSubview(makeWidthDividerView())
        configureBreakTimeButton()
        
        self.breakTimeStackView.spacing = safeArea.layoutFrame.width * 0.1
        
        let stackWidthSize = self.view.frame.width - Constant.outerMargin * 2
        let allSpacing: CGFloat = 3 * self.breakTimeStackView.spacing
        let mainSize = breakTimeLabel.intrinsicContentSize.width + breakTimeButton.intrinsicContentSize.width + allSpacing
        let targetSize = (stackWidthSize - mainSize) / 2
        
        leftDividerView.snp.remakeConstraints { make in
            make.width.equalTo(targetSize)
        }
    }
    
    func configureBreakTimeButton() {
        self.breakTimeButton.snp.makeConstraints { make in
            make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width).multipliedBy(0.15)
        }
    }
}

// MARK: - BindViewModel
private extension DailyInfoCreateViewController {
    func bindViewModel() {
        let input = DailyInfoEditViewModel.Input(nextButtonTapEvent: nextButtonTappedEvent,
                                                 cancelButtonTapEvent: cancelButton.rx.tap.asObservable(),
                                                 modelTitle: modelTitleSubject,
                                                 modelFocusTime: modelFocusTimeSubject,
                                                 modelBreakTime: modelBreakTimeSubject)
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag) else {
            return
        }
        
        output.isFillAllInfo
            .subscribe(onNext: { [weak self] isFillAllInfo in
                if isFillAllInfo == false {
                    self?.alertFailure()
                }
            }).disposed(by: self.disposeBag)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: "실패",
                                      message: "빈 값이 있는지 확인해주세요",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}
