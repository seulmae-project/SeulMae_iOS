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
        var workplace: Workplace?

        func makeContentView() -> UIView & UIContentView {
            return ApplicationContentView(self)
        }
    }

    // MARK: - UI Properties

    private let placeInfoView = PlaceInfoView()

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
        [placeInfoView]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(20)
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

    // MARK: - Configuration Methods

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        placeInfoView.updateInfo(config.workplace, isShowPending: true)
    }
}
