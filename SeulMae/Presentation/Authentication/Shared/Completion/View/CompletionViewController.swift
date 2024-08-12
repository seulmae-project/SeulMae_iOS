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

    private let completionGuideLabel: UILabel = .callout()
    private let stepGuideLabel: UILabel = .title()
    private let completionImageView: UIImageView = UIImageView()
    private let nextStepButton: UIButton = .common()
    
    // MARK: - Dependencies
    
    private var viewModel: CompletionViewModel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupConstraints()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {

        let output = viewModel.transform(
            .init(nextStep: nextStepButton.rx.tap.asSignal())
        )
        
        Task {
            for await item in output.item.values {
                completionGuideLabel.text = item.description
                stepGuideLabel.text = item.title
                completionImageView.image = item.image
                nextStepButton.setTitle(item.nextStep, for: .normal)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func setupConstraints() {
        let completionVStack = UIStackView(arrangedSubviews: [
            completionGuideLabel, stepGuideLabel, completionImageView
        ])
        completionVStack.axis = .vertical
        completionVStack.alignment = .center
        completionVStack.spacing = 8.0
        completionVStack.setCustomSpacing(26, after: stepGuideLabel)
        
        let subViews: [UIView] = [
            completionVStack, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        completionVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(144)
            make.centerX.equalToSuperview()
        }
        
        completionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}

