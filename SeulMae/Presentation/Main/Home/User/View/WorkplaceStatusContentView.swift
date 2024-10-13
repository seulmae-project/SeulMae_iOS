//
//  WorkplaceStatusContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/13/24.
//

import UIKit

final class WorkplaceStatusContentView: UIView, UIContentView {

    struct Configuration: UIContentConfiguration {
        var name: String? = ""
        var workTime: String? = ""
        var message: String? = ""
        // var messageStatus:

        func makeContentView() -> UIView & UIContentView {
            return WorkplaceStatusContentView(self)
        }
    }

    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = UIColor(hexCode: "4C71F5")
        // view.trackTintColor = .white
        view.progress = 0.5
        return view
    }()

    let nameLabel: UILabel = .common(title: "팀슬매", size: 17, weight: .bold, color: UIColor(hexCode: "4C71F5"))

    let workTimeLabel: UILabel = .common(title: "09:00 - 10:00", size: 12, weight: .regular, color: UIColor(hexCode: "A7AAB2"))

    let messageLabel: UILabel = .common(title: "한시간 승인 완료", size: 14, weight: .semibold, color: UIColor(hexCode: "4C71F5"))

    let messageIconImageView: UIImageView = .common(image: ._1)

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

        backgroundColor = UIColor(hexCode: "F6F8FF")

        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        let nameAndTimeStack = UIStackView()
        nameAndTimeStack.axis = .vertical
        nameAndTimeStack.spacing = 5.0
        [nameLabel, workTimeLabel]
            .forEach(nameAndTimeStack.addArrangedSubview(_:))

        let messageStack = UIStackView()
        messageStack.spacing = 5.0
        [messageLabel, messageIconImageView]
            .forEach(messageStack.addArrangedSubview(_:))

        let bubbled = progressView.bubbled(
            color: .white, horizontal: 2.0, vertical: 2.0)
        bubbled.transform = CGAffineTransform(rotationAngle: .pi / -2)

        let contentStack = UIStackView()
        contentStack.spacing = 9.0
        contentStack.alignment = .center
        [bubbled, nameAndTimeStack, messageStack]
            .forEach(contentStack.addArrangedSubview(_:))

        messageLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            bubbled.heightAnchor.constraint(equalToConstant: 7.0),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        
    }
}
