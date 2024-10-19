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

    let leadingIconImageView: UIImageView = .common(image: .starCircle)
    let titlelabel: UILabel = .common(title: "읽지 않은 알람이 있어요", size: 14, weight: .semibold)
    let countLabel: UILabel = .common(size: 14, weight: .semibold, color: UIColor(hexCode: "BDBEC0"))
    let trailingImageView: UIImageView = .common(image: .caretRight)

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
        contentStack.alignment = .center
        contentStack.spacing = 8.0

        [leadingIconImageView, titlelabel, countLabel, trailingImageView]
            .forEach(contentStack.addArrangedSubview(_:))

        countLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        countLabel.textAlignment = .right

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
        countLabel.text =  "\(config.remiderCount ?? 0)건"
    }
}
