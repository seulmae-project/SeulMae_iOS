//
//  UserHomeViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UserHomeViewController: BaseViewController {
    
    // MARK: UI
    
    private let notiRightBarButton = UIBarButtonItem(image: .bell, style: .plain, target: nil, action: nil)
    
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
    
    private let dailyWorkView = DailyWorkView()
    private let calendarView = CalendarView()
    
    // MARK: - Properties
    
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
        let onLoad = rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in return () }
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
        // navigationItem.rightBarButtonItem = notiRightBarButton
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        [dailyWorkView, calendarView]
            .forEach {
                scrollView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
    
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            dailyWorkView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: inset),
            dailyWorkView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -inset),
            dailyWorkView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            dailyWorkView.heightAnchor.constraint(equalToConstant: 143),
            
            calendarView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: inset),
            calendarView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -inset),
            calendarView.topAnchor.constraint(equalTo: dailyWorkView.bottomAnchor, constant: 52),
        ])
    }
}
