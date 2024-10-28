//
//  CompletionViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CompletionViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: CompletionViewModel) -> CompletionViewController {
        let view = CompletionViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: UI

    private let descriptionLabel: UILabel = .callout()
    
    private let titleLabel: UILabel = {
        let label = UILabel.title()
        label.textAlignment = .center
        return label
    }()
    
    private let completionImageView: UIImageView = UIImageView()
    
    private let nextStepButton: UIButton = .common()
    
    // MARK: - Dependencies
    
    private var viewModel: CompletionViewModel!
    
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let output = viewModel.transform(
            .init(nextStep: nextStepButton.rx.tap.asSignal())
        )
        
        Task {
            for await item in output.item.values {
                descriptionLabel.text = item.description
                titleLabel.text = item.title
                completionImageView.image = item.image
                nextStepButton.setTitle(item.nextStep, for: .normal)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 8.0

        view.addSubview(contentStack)
        view.addSubview(nextStepButton)
        
        contentStack.addArrangedSubview(completionImageView)
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(titleLabel)
        
        contentStack.setCustomSpacing(16, after: completionImageView)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextStepButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextStepButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.heightAnchor.constraint(equalToConstant: 56),
            
            completionImageView.widthAnchor.constraint(equalToConstant: 120),
            completionImageView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
}

