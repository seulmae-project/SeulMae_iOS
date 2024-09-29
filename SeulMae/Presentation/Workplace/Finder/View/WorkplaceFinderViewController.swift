//
//  WorkplaceFinderViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit

final class WorkplaceFinderViewController: UIViewController {
    
    // MARK: - UI
    
    private let titleLabel: UILabel = .title(title: "참여중인 근무지가 없어요")
    private let searchWorkplaceButton: UIButton = .common(title: "찾아보기")
    private let createWorkplaceButton: UIButton = .common(title: "생성하기")
    private let pendingLabel: UILabel = .title(title: "승인 대기중인 근무지")
    
    // MARK: - Properties
    
    private var viewModel: WorkplaceFinderViewModel
    
    // MARK: - Life Cycle Methods
    
    init(viewModel: WorkplaceFinderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let output = viewModel.transform(
            .init(
                search: searchWorkplaceButton.rx.tap.asSignal(),
                create: createWorkplaceButton.rx.tap.asSignal()
            )
        )
        
        Task {
            
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        let buttonStack = UIStackView()
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8.0
        
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)
        view.addSubview(pendingLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        pendingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(searchWorkplaceButton)
        buttonStack.addArrangedSubview(createWorkplaceButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            buttonStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            pendingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pendingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            pendingLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 12),
            
            // Constraint button height
            buttonStack.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
