//
//  PwRecoveryVC.swift
//  SeulMae
//
//  Created by 조기열 on 11/2/24.
//

import UIKit

class PwRecoveryViewController: BaseViewController {

    // MARK: - UI Properties

    private let titleLabel = UILabel.ext.common("비밀번호 재설정", font: .pretendard(size: 24, weight: .semibold))
    private let descriptionLabel = UILabel.ext.common("새로운 비밀번호를 입력해주세요", font: .pretendard(size: 13, weight: .regular))
        .ext.highlight(font: .pretendard(size: 13, weight: .semibold), textColor: "4C71F5", words: "새로운 비밀번호")

    private let pwTextField = UITextField.ext.tf(placeholder: "변경 비밀번호")
        .ext.pw()
        .ext.backgroundColor(.ext.hex("F2F5FF"))
        .ext.activeImage(image: .authTextFieldCheck)
    private let pwValidationResultLabel = UILabel.ext.config(font: .pretendard(size: 12, weight: .regular))
    private let repeatedPwTextField = UITextField.ext.tf(placeholder: "변경 비밀번호 확인")
        .ext.pw()
        .ext.backgroundColor(.ext.hex("F2F5FF"))
        .ext.activeImage(image: .authTextFieldCheck)

    private let repeatedPwValidationResultLabel = UILabel.ext.config(font: .pretendard(size: 12, weight: .regular))
    private let resetButton = UIButton.ext.common(title: "확인")

    // MARK: - Dependencies

    private var viewModel: PwRecoveryViewModel!

    // MARK: - Life Cycle Methods

    convenience init(viewModel: PwRecoveryViewModel) {
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
                password: pwTextField.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPwTextField.rx.text.orEmpty.asDriver(),
                onReset: resetButton.rx.tap.asSignal()
            ))

        output.laoding
            .drive(loadingIndicator.ext.isAnimating)
            .disposed(by: disposeBag)

        output.validatedPassword
            .drive(pwValidationResultLabel.ext.validationResult)
            .disposed(by: disposeBag)

        output.validatedPasswordRepeated
            .drive(repeatedPwValidationResultLabel.ext.validationResult)
            .disposed(by: disposeBag)

        output.resetEnabled
            .drive(resetButton.ext.isEnabled)
            .disposed(by: disposeBag)
    }

    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.spacing = 8.0
        [titleLabel.ext.padding(leading: 12), descriptionLabel.ext.padding(leading: 12)]
            .forEach(titleStack.addArrangedSubview(_:))

        let pwStack = UIStackView()
        pwStack.spacing = 8.0
        pwStack.axis = .vertical
        [pwTextField, pwValidationResultLabel.ext.padding(leading: 12)]
            .forEach(pwStack.addArrangedSubview(_:))

        let repeatedPwStack = UIStackView()
        repeatedPwStack.spacing = 8.0
        repeatedPwStack.axis = .vertical
        [repeatedPwTextField, repeatedPwValidationResultLabel.ext.padding(leading: 12)]
            .forEach(repeatedPwStack.addArrangedSubview(_:))

        let textFieldStack = UIStackView()
        textFieldStack.axis = .vertical
        textFieldStack.spacing = 12
        [pwStack, repeatedPwStack]
            .forEach(textFieldStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        [titleStack, textFieldStack, resetButton]
            .forEach(contentStack.addArrangedSubview(_:))
        contentStack.setCustomSpacing(40, after: titleStack)
        contentStack.setCustomSpacing(20, after: textFieldStack)

        let views = [contentStack]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let insets = CGFloat(24)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 58),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

