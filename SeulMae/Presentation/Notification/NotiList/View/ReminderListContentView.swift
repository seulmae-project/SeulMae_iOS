//
//  ReminderListContentView.swift
//  SeulMae
//
//  Created by 조기열 on 8/20/24.
//

import UIKit

final class ReminderListContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var typeIcon: UIImage?
        var type: String?
        var title: String?
        var message: String?
        var date: Date?
        
        func makeContentView() -> UIView & UIContentView {
            return ReminderListContentView(self)
        }
    }
    
    private let typeIconImageView: UIImageView = UIImageView()
    private let typeLabel: UILabel = .common(size: 13, weight: .medium, color: UIColor(hexCode: "6D7074"))
    private let dateLabel: UILabel = .common(size: 12, weight: .medium, color: UIColor(hexCode: "6D7074"))
    private let titleLabel: UILabel = .common(size: 16, weight: .bold, numOfLines: 1)
    private let messageLabel: UILabel = .common(size: 14, weight: .medium, color: UIColor(hexCode: "313946"), numOfLines: 2)

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

        let headerStack = UIStackView()
        headerStack.alignment = .center
        headerStack.distribution = .equalCentering
        [typeLabel, dateLabel]
            .forEach(headerStack.addArrangedSubview(_:))

        let bodyStack = UIStackView()
        bodyStack.axis = .vertical
        bodyStack.spacing = 8.0
        [headerStack, messageLabel]
            .forEach(bodyStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.spacing = 4.0
        contentStack.alignment = .top
        [typeIconImageView, bodyStack]
            .forEach(contentStack.addArrangedSubview(_:))

        self.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeIconImageView.widthAnchor.constraint(equalToConstant: 20),
            typeIconImageView.heightAnchor.constraint(equalToConstant: 20),

            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        typeIconImageView.image = config.typeIcon
        typeLabel.text = config.type
        dateLabel.text = dateFormatter.string(from: config.date ?? Date())
        titleLabel.text = config.title
        messageLabel.text = config.message
    }
}

