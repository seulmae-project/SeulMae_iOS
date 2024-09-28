//
//  WorkRecordViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import UIKit

final class WorkRecordViewController: UIViewController {
    
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
        label.font = .pretendard(size: 17, weight: .regular)
        return label
    }()
    
    private let timeRecordingView = WorkStatusView()
    
    private let getOffWorkButton: UIButton = {
        let button = UIButton()
        button.setTitle("퇴근하기", for: .normal)
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
    }()
    
    // MARK: - Dependencies
    
    private var viewModel: WorkRecordViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkRecordViewModel) {
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
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                getOffWork: getOffWorkButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        contentStack.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(timeRecordingView)
        contentStack.addArrangedSubview(getOffWorkButton)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        contentStack.addArrangedSubview(spacer)
        
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor),
            
            getOffWorkButton.heightAnchor.constraint(equalToConstant: 56),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
