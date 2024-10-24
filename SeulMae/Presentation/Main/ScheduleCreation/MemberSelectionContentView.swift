//
//  MemberSelectionContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit

final class MemberSelectionContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var onCheck: ((Bool) -> Void)?
        var memberImageURL: String?
        var memberName: String?
        var description: String?

        func makeContentView() -> UIView & UIContentView {
            return MemberSelectionContentView(self)
        }
    }

    private var onCheck: ((Bool) -> Void)?
    private let checkButton: UIButton = Ext.image(.checkmark)
    private let memberImageView: UIImageView = Ext.user()
    private let memberNameLabel: UILabel = Ext.common()
    private let descriptionLabel: UILabel = Ext.common()

    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 8.0
        [memberNameLabel, descriptionLabel]
            .forEach(labelStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.spacing = 12
        [checkButton, memberImageView, labelStack]
            .forEach(contentStack.addArrangedSubview(_:))
        
        let insets = CGFloat(0)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        onCheck = config.onCheck
        memberImageView.ext.url(config.memberImageURL)
        memberNameLabel.text = config.memberName
        descriptionLabel.text = config.description
    }
}
