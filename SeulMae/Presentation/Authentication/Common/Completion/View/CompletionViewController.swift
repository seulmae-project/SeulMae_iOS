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
    
    // MARK: - Dependency
    
    private var viewModel: CompletionViewModel!
    
    private let completionGuideLabel: UILabel = .callout()
    private let stepGuideLabel: UILabel = .title()
    private let completionImageView: UIImageView = UIImageView()
    private let nextStepButton: UIButton = .common()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {

        let output = viewModel.transform(
            .init(nextStep: nextStepButton.rx.tap.asSignal())
        )
        
        Task {
            for await type in output.item.values {
                completionGuideLabel.text = type.completion
                stepGuideLabel.text = type.stepGuide
                completionImageView.image = type.image
                nextStepButton.setTitle(type.stepGuide, for: .normal)
            }
        }
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
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

