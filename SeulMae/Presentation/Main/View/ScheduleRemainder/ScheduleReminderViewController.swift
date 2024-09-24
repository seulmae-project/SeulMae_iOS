//
//  ScheduleReminderViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import UIKit

final class ScheduleReminderViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "금일의 근무 일정"
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let scheduleReminderLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 일정까지 남은 시간: 00:00"
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let scheduleListStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let workStartButton: UIButton = {
        let button = UIButton()
        button.setTitle("출근", for: .normal)
        return button
    }()
    
    private let registerAttendnaceButton: UIButton = {
        let button = UIButton()
        button.setTitle("근무 등록", for: .normal)
        return button
    }()
    
    // MARK: - Properties
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
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
    }
    
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
                onRegister: registerAttendnaceButton.rx.tap.asSignal(),
                onWorkStart: workStartButton.rx.tap.asSignal()
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
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        
        //        let leftLabelVStack = UIStackView(arrangedSubviews: [
        //            titleLabel, nextScheduleRemaindLabel
        //        ])
        //        leftLabelVStack.axis = .vertical
        //        leftLabelVStack.spacing = 4.0
        //
        //        let rightLabelVStack = UIStackView(arrangedSubviews: [
        //            label3, label4
        //        ])
        //        rightLabelVStack.axis = .vertical
        //        rightLabelVStack.spacing = 4.0
        //
        //        let labelHStack = UIStackView(arrangedSubviews: [
        //            leftLabelVStack, rightLabelVStack
        //        ])
        //        labelHStack.distribution = .equalCentering
        //
        //        progressView.progressTintColor = .primary
        //        progressView.trackTintColor = .systemBackground
        //
        //        let contentStack = UIStackView(arrangedSubviews: [
        //            labelHStack, progressView
        //        ])
        //        contentStack.axis = .vertical
        //        contentStack.spacing = 8.0
        //
        //        view.addSubview(contentStack)
        //
        //        contentStack.translatesAutoresizingMaskIntoConstraints = false
        //
        //        NSLayoutConstraint.activate([
        //            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //            contentStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        //            contentStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        //        ])
    }
}
