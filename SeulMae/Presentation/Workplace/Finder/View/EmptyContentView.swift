//
//  EmptyContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/19/24.
//

import UIKit

class EmptyContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var image: UIImage?
        var message: String?

        func makeContentView() -> UIView & UIContentView {
            return EmptyContentView(self)
        }
    }

    // MARK: - UI Properties

    private let imageView: UIImageView = UIImageView()
    private let messageLabel: UILabel = .common(size: 14, weight: .semibold, color: UIColor(hexCode: "BCC7DD"))

    // MARK: - Properties

    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }

    // MARK: Life Cycle Methods

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 12
        [imageView, messageLabel]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(0)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 56),
            imageView.heightAnchor.constraint(equalToConstant: 56),
            
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            contentStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    // MARK: - Configuration Methods

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        imageView.image = config.image
        messageLabel.text = config.message
    }
}
