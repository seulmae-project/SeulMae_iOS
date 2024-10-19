//
//  ApplicationContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/19/24.
//

import UIKit
import Kingfisher

class ApplicationContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var imageURL: String?
        var name: String?
        var address: String?
        var subAdress: String?

        func makeContentView() -> UIView & UIContentView {
            return ApplicationContentView(self)
        }
    }

    // MARK: - UI Properties

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
        imageView.layer.cornerCurve = .continuous
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hexCode: "EEEEEE")
        return imageView
    }()

    private let nameLabel: UILabel = .common(size: 20, weight: .semibold)

    private let addressLabel: UILabel = .common(size: 11, weight: .regular, color: UIColor(hexCode: "BDBEC0"))

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

        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 4.0
        [nameLabel, addressLabel]
            .forEach(labelStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.alignment = .center
        contentStack.spacing = 8.0
        [imageView, labelStack]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 84),
            imageView.heightAnchor.constraint(equalToConstant: 64),

            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
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
        nameLabel.text = config.name
        addressLabel.text = "\(config.address ?? "") \(config.subAdress ?? "")"
    }
}
