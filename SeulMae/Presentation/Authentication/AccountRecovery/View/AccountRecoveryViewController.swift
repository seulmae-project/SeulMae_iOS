//
//  IDRecoveryViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import UIKit

final class AccountRecoveryViewController: UIViewController {

    // MARK: - UI
    
    private let titleLabel: UILabel = .title(title: "계정 아이디를\n확인해 주시길 바랍니다")
    private let accountLabel: UILabel = .callout(title: "계정 아이디")
    private let foundAccountLabel: UILabel = .callout()
    private let movePasswordRecovery: UIButton = .callout(title: "비밀번호를 잃어버리셨나요?")
    private let nextStepButton: UIButton = .common(title: "로그인 하기")
    
    // MARK: - Dependency
    
    private var viewModel: AccountRecoveryViewModel
    
    // MARK: - Life Cycle
    
    init(viewModel: AccountRecoveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    private func bindSubviews() {
        let output = viewModel.transform(
            .init(
                movePasswordRecovery: movePasswordRecovery.rx.tap.asSignal(),
                moveSignin: nextStepButton.rx.tap.asSignal()
            )
        )
        // Binds the view to the item
        Task {
            for await item in output.item.values {
                foundAccountLabel.text = item.foundAccount
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavItem() {
        navigationController?.title = "아이디 찾기"
    }

    private func setupConstraints() {
        let accountStack = UIStackView()
        accountStack.axis = .vertical
        accountStack.alignment = .center
        accountStack.spacing = 4.0
        accountStack.layoutMargins = .init(top: 32, left: 0, bottom: 32, right: 0)
        accountStack.isLayoutMarginsRelativeArrangement = true
        accountStack.backgroundColor = .lightPrimary
        accountStack.layer.cornerRadius = 16
        accountStack.layer.cornerCurve = .continuous
        
        view.addSubview(titleLabel)
        view.addSubview(accountStack)
        view.addSubview(nextStepButton)
        view.addSubview(movePasswordRecovery)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        accountStack.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        movePasswordRecovery.translatesAutoresizingMaskIntoConstraints = false
        
        accountStack.addArrangedSubview(accountLabel)
        accountStack.addArrangedSubview(foundAccountLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            accountStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            accountStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 52),
            accountStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextStepButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nextStepButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.heightAnchor.constraint(equalToConstant: 56),
            
            movePasswordRecovery.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            movePasswordRecovery.bottomAnchor.constraint(equalTo: nextStepButton.topAnchor, constant: -12),
            movePasswordRecovery.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
