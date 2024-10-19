//
//  ReminderCountContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/19/24.
//

import UIKit

final class ReminderCountContentView: UIView, UIContentView {

    struct Configuration: UIContentConfiguration {
        var remiderCount: Int? = 0

        func makeContentView() -> UIView & UIContentView {
            return ReminderCountContentView(self)
        }
    }

    let iconImageView = UIImageView()
    let titlelabel: UILabel = .common(size: 14, weight: .semibold)
    let descriptionLabel: UILabel = .common(size: 14, weight: .semibold, color: UIColor(hexCode: "BDBEC0"))
    let iconsImageView = UIImageView()

    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center

        [iconImageView, titlelabel]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(16)
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

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        descriptionLabel.text =  "\(config.remiderCount ?? 0)건"
    }
}
