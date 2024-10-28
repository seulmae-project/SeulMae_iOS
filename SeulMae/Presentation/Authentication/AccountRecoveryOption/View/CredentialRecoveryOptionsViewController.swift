//
//  CredentialRecoveryOptionsViewController.swift
//  SeulMae
//
//  Created by 조기열 on 8/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CredentialRecoveryOptionsViewController: UIViewController {
    
    // let recoveryOptionRelay = PublishRelay<CredentialRecoveryOption>()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "계정 또는 비밀번호 찾기"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let recoveryAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 찾기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let recoveryPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    // init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        let insets = UIEdgeInsets(top: 48, left: 20, bottom: 48, right: 20)
        contentStack.layoutMargins = insets
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(recoveryAccountButton)
        contentStack.addArrangedSubview(recoveryPasswordButton)
        
        contentStack.setCustomSpacing(24, after: titleLabel)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            recoveryAccountButton.heightAnchor.constraint(equalToConstant: 44),
            recoveryPasswordButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        recoveryAccountButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
        recoveryPasswordButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
    }
    
    @objc func didTapOptionButton(_ sender: UIButton) {
//        recoveryOptionRelay.accept((sender == recoveryAccountButton) ? .account : .password)
        self.dismiss(animated: true)
    }
}
