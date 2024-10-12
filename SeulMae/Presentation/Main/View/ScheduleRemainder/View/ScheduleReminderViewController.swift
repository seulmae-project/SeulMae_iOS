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
    
    private(set) lazy var scrollView: UIScrollView = {
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
        let onRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: onRefresh,
                onWorkStart: workStartButton.rx.tap.asSignal(),
                onRegister: registerAttendnaceButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
        
        Task {
            for await item in output.item.values {
                scheduleReminderLabel.text = item.reminder
                item.inToday
                    .map { LeftScheduleView.init(title: $0.title) }
                    .forEach(scheduleListStack.addArrangedSubview)
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
        
        // let spacer = UIView()
        // spacer.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        // contentStack.addArrangedSubview(spacer)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
      
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: inset),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -inset),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: inset),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -inset),
            
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -(2 * inset)),

            buttonStack.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Swift.print("-- scrollView contentSize: \(scrollView.contentSize)")
    }
}
