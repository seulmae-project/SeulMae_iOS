//
//  NotiContentView.swift
//  SeulMae
//
//  Created by 조기열 on 8/20/24.
//

import UIKit

final class NotiContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var type: String = ""
        var title: String = ""
        var message: String = ""
        var date: Date = Date()
        
        func makeContentView() -> UIView & UIContentView {
            return NotiContentView(self)
        }
    }
    
    private let typeLabel: UILabel = .common(size: 13, weight: .regular, color: UIColor(hexCode: "393939", alpha: 0.5), numOfLines: 1)
    private let dateLabel: UILabel = .common(size: 11, weight: .regular, color: UIColor(hexCode: "393939", alpha: 0.5), numOfLines: 1)
    private let titleLabel: UILabel = .common(size: 16, weight: .bold, numOfLines: 1)
    private let messageLabel: UILabel = .common(size: 16, weight: .regular, numOfLines: 1)

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
        headerStack.addArrangedSubview(typeLabel)
        headerStack.addArrangedSubview(dateLabel)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.addArrangedSubview(headerStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(messageLabel)
        contentStack.setCustomSpacing(8.0, after: headerStack)
        
        let insets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        contentStack.directionalLayoutMargins = insets
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        self.addSubview(contentStack)
        
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
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        typeLabel.text = config.type
        dateLabel.text = dateFormatter.string(from: config.date)
        titleLabel.text = config.title
        messageLabel.text = config.message
    }
}

