//
//  AttendanceViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/19/24.
//

import UIKit

final class AttendanceViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let scheduleRemaindLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let scheduleListStack: UIStackView = {
        let stack = UIStackView()
        
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
    
    private let viewModel: AttendanceViewModel
    
    // MARK: Life Cycle Methods
    
    init(viewModel: AttendanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindSubviews()
    }
    
    private func bindSubviews() {
        
    }
    
    private func setupView() {
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
