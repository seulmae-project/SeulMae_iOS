//
//  ScheduleReminderViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import UIKit

final class ScheduleReminderViewController: UIViewController {
    
    // MARK: - UI
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "금일의 근무 일정을 확인해 보세요"
        label.font = .pretendard(size: 24, weight: .medium)
        return label
    }()
    
    private let scheduleReminderLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 일정까지 00시간 00분 남았어요"
        label.font = .pretendard(size: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let scheduleListStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let workStartButton = UIButton.half(title: "출근 하기", highlight: true)
    private let registerAttendnaceButton = UIButton.half(title: "등록 하기", highlight: true)
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
    }()
   
    // MARK: - Dependencies
    
    private let viewModel: ScheduleReminderViewModel
    
    // MARK: Life Cycle Methods
    
    init(viewModel: ScheduleReminderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        bindSubviews()
        setEmptyScheduleView()
    }
    
    // MARK: - Private
    
    private func setEmptyScheduleView() {
        guard scheduleListStack.subviews.isEmpty else { return }
        let emptyView = UIView()
        emptyView.heightAnchor.constraint(equalToConstant: 56)
            .isActive = true
        scheduleListStack.addArrangedSubview(emptyView)
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                startDate: .empty(),
                endDate: .empty(),
                memo: .empty(),
                onRequest: .empty(), // deprecated
                onWorkStart: workStartButton.rx.tap.asSignal(),
                onRegister: registerAttendnaceButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await _ in output.loading.values {
                
            }
        }
        
        Task {
            for await item in output.item.values {
                switch item.itemType {
                case .reminder:
                    scheduleReminderLabel.text = item.reminder
                case .workScheduleList:
                    break // content view able..?
                }
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let buttonStack = UIStackView()
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(workStartButton)
        buttonStack.addArrangedSubview(registerAttendnaceButton)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(scheduleReminderLabel)
        contentStack.addArrangedSubview(scheduleListStack)
        contentStack.addArrangedSubview(buttonStack)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        contentStack.addArrangedSubview(spacer)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentStack.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor, constant: -20),
            
            buttonStack.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}
