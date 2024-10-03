//
//  ManagerHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ManagerHomeViewController: BaseViewController {
    
    // MARK: UI
    
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
        label.text = "금일의 근무 요청을\n확인해 주세요"
        label.numberOfLines = 2
        label.font = .pretendard(size: 24, weight: .medium)
        return label
    }()
    
    private let attendRequestStatusView = AttendRequestStatusView()
    private let notiRightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    private let calendarView = CalendarView()
    
    // MARK: - Dependencies
 
    private var viewModel: ManagerHomeViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: ManagerHomeViewModel) {
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
                showDetails: .empty()
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
        scrollView.addSubview(attendRequestStatusView)

//        scrollView.addSubview(calendarView)
//        scrollView.addSubview(emptyView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        attendRequestStatusView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
    
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: inset),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: inset),
            
            attendRequestStatusView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            attendRequestStatusView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -inset),
            attendRequestStatusView.topAnchor.constraint(equalTo: titleLabel.topAnchor),

//            calendarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
//            calendarView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
//            calendarView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            // calendarView.heightAnchor.constraint(equalTo: calendarView.widthAnchor),
//            
//            emptyView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
//            emptyView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
//            emptyView.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
//            emptyView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
}
