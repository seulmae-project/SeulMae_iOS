//
//  AlertViewController.swift
//  SeulMae
//
//  Created by 조기열 on 10/21/24.
//

import UIKit
import RxSwift
import RxCocoa

class AlertViewController: BaseViewController {
    let contentView: UIView = UIView()
    let contentStack: UIStackView = UIStackView()
    let iconImageView: UIImageView = .common(image: .checkCircleBlue)
    let titleLabel: UILabel = .common(size: 24, weight: .semibold)
    let messageLabel: UILabel = .common(size: 13, weight: .regular)
    let buttonStack: UIStackView = UIStackView()
    let xButton: UIButton = .image(.xMark)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.contentView.transform = .identity
            self?.contentView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.contentView.transform = .identity
            self?.contentView.isHidden = true
        }
    }

    func configureHierarchy() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 8.0
        contentView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 12
        let views = [iconImageView, titleLabel, messageLabel, buttonStack]
        views.forEach(contentStack.addArrangedSubview(_:))

        [contentStack, buttonStack]
            .forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            contentView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),

            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            contentStack.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -48),

            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),
            
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            buttonStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            buttonStack.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    public func addAction(title: String?, handler: ((String) -> Void)? = nil) {
        let action = UIButton()
        action.titleLabel?.font = .pretendard(size: 16, weight: .bold)
        action.setTitle(title, for: .normal)
        action.setTitleColor(.white, for: .normal)
        action.backgroundColor = UIColor(hexCode: "4C71F5")
        action.layer.cornerRadius = 8.0
        action.layer.cornerCurve = .continuous
        action.addAction(UIAction(handler: { _ in
            handler?(title ?? "")
        }), for: .touchUpInside)
        buttonStack.addArrangedSubview(action)
    }
}
