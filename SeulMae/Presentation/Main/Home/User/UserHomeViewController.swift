//
//  UserHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UserHomeViewController: UIViewController {
    
    // MARK: UI
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번달의\n출퇴근 기록을 확인해 보세요"
        label.numberOfLines = 2
        label.font = .pretendard(size: 24, weight: .medium)
        return label
    }()
    
    private let notiRightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    private let currentStatusView = CurrentStatusView()
    private let calendarView = CalendarView()
    
    // MARK: - Properties
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    private let attendRelay = PublishRelay<AttendRequest>()
    private let addRelay = PublishRelay<AttendRequest>()
    
    // MARK: - Dependencies
 
    private var viewModel: UserHomeViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: UserHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupNavItem()
        setupConstraints()
        bindSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                refresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
                showNotis: notiRightBarButton.rx.tap.asSignal(),
                showDetails: .empty(),
                attend: attendRelay.asSignal(),
                add: addRelay.asSignal()
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
    
    private func setupNavItem() {
        navigationItem.rightBarButtonItem = notiRightBarButton
    }
    
    private func setupConstraints() {
        let emptyView = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(calendarView)
        scrollView.addSubview(currentStatusView)
        scrollView.addSubview(emptyView)
        view.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        currentStatusView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
    
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            // titleLabel.heightAnchor.constraint(equalToConstant: 300),

            calendarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            calendarView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            calendarView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            // calendarView.heightAnchor.constraint(equalTo: calendarView.widthAnchor),
            
            emptyView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            emptyView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            emptyView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            emptyView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
}
