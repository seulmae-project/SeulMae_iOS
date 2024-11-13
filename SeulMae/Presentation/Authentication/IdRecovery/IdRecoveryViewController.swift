//
//  IdRecoveryViewController.swift
//  SeulMae
//
//  Created by 조기열 on 11/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class IdRecoveryViewController: BaseViewController {

    // MARK: - UI Properties

    private let titleLabel = UILabel.ext.common("아이디 찾기", font: .pretendard(size: 24, weight: .semibold))
    private let descriptionLabel = UILabel.ext.common("회원님의 계정 아이디를 확인해 주세요", font: .pretendard(size: 13, weight: .regular))
        .ext.highlight(font: .pretendard(size: 13, weight: .semibold), textColor: "4C71F5", words: "계정 아이디")

    private let _accountIdLabel = UILabel.ext.common("계정 아이디", font: .pretendard(size: 14, weight: .regular))
    private let accountIdLabel = UILabel.ext.config(font: .pretendard(size: 18, weight: .medium))

    private let recoveryPasswordButton = UIButton.ext.common(title: "비밀번호 재설정")
        .ext.font(.pretendard(size: 16, weight: .bold))
        .ext.config(textColor: .ext.hex("4C71F5"), backgroundColor: .ext.hex("F2F5FF"))
    private let signInButton = UIButton.ext.common(title: "로그인")
        .ext.font(.pretendard(size: 16, weight: .bold))
        .ext.config(textColor: .white, backgroundColor: .ext.hex("4C71F5"))

    // MARK: - Dependencies

    private var viewModel: IdRecoveryViewModel!

    // MARK: - Life Cycle Methods

    convenience init(viewModel: IdRecoveryViewModel) {
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
                passwordRecovery: recoveryPasswordButton.rx.tap.asSignal(),
                signIn: signInButton.rx.tap.asSignal()
            ))

        output.accountId
            .drive(with: self, onNext: { (self, accountId) in
                self.accountIdLabel.text = accountId
            })
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

        let foundIdStack = UIStackView()
        foundIdStack.alignment = .leading
        foundIdStack.axis = .vertical
        [_accountIdLabel, accountIdLabel]
            .forEach(foundIdStack.addArrangedSubview(_:))
        foundIdStack.ext.padding(horizontal: 20, vertical: 25)
        foundIdStack.backgroundColor = .ext.hex("F2F5FF")
        foundIdStack.ext.round(radius: 8.0)

        let buttonStack = UIStackView()
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        [recoveryPasswordButton, signInButton]
            .forEach(buttonStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        [titleStack, foundIdStack, buttonStack]
            .forEach(contentStack.addArrangedSubview(_:))
        contentStack.setCustomSpacing(32, after: titleStack)
        contentStack.setCustomSpacing(24, after: foundIdStack)

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

