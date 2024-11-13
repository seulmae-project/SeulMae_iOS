//
//  CompletionViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CompletionViewController: BaseViewController {

    // MARK: UI Properties

    private let completionImageView = UIImageView
        .ext.common(.authCompletionCheck)
        .ext.size(width: 100, height: 100)
    private let titleLabel = UILabel
        .ext.config(font: .pretendard(size: 24, weight: .semibold))
        .ext.lines(2)
        .ext.center()
    
    private let doneButton = UIButton
        .ext.common(title: "확인")

    // MARK: - Dependencies
    
    private var viewModel: CompletionViewModel!
    
    // MARK: - Life Cycle Methods

    convenience init(viewModel: CompletionViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        bindInternalSubviews()
    }

    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let output = viewModel.transform(
            .init(
                onDone: doneButton.rx.tap.asSignal()
            ))

        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        [completionImageView, titleLabel, doneButton]
            .forEach(contentStack.addArrangedSubview(_:))
        contentStack.setCustomSpacing(16, after: completionImageView)
        contentStack.setCustomSpacing(52, after: titleLabel)

        let views = [contentStack]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let insets = CGFloat(24)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            doneButton.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
        ])
    }
}

