//
//  UnhandledAttContentView.swift
//  SeulMae
//
//  Created by 조기열 on 11/12/24.
//

import UIKit

class UnhandledAttContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var att: Attendance?
        var onTap:  ((Bool) -> Void)?

        func makeContentView() -> UIView & UIContentView {
            return UnhandledAttContentView(self)
        }
    }

    let userImageView = UIImageView.user()
    let usernameLabel = UILabel.ext
        .config(font: .pretendard(size: 14, weight: .medium))
    let totalTimeLabel = UILabel.ext
        .config(font: .pretendard(size: 14, weight: .bold), color: .ext.hex("4C71F5"))
    let workTimeLabel = UILabel.ext
        .config(font: .pretendard(size: 12, weight: .regular), color: .ext.hex("818B9B"))
    let noButton = UIButton.ext.small(title: "거절")
    let okButton = UIButton.ext.small(title: "승인")

    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        let nameStack = UIStackView()
        nameStack.spacing = 4.0
        [usernameLabel, totalTimeLabel]
            .forEach(nameStack.addArrangedSubview(_:))

        let userInfoStack = UIStackView()
        userInfoStack.axis = .vertical
        [nameStack, workTimeLabel]
            .forEach(userInfoStack.addArrangedSubview(_:))

        let userImageStack = UIStackView()
        userImageStack.spacing = 4.0
        userImageStack.alignment = .center
        [userImageView, userInfoStack]
            .forEach(userImageStack.addArrangedSubview(_:))

        let buttonStack = UIStackView()
        buttonStack.spacing = 4.0
        [noButton, okButton].forEach(buttonStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.alignment = .center
        contentStack.distribution = .equalCentering
        [userImageStack, buttonStack]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration,
              let att = config.att else { return }
        usernameLabel.text = att.username
        totalTimeLabel.text = String(att.totalWorkTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startTime = dateFormatter.string(from: att.workStartDate)
        let endTime = dateFormatter.string(from: att.workEndDate)
        workTimeLabel.text = startTime + " ~ " + endTime
    }
}
