//
//  EmptyView.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

class SMEmptyView: UIView {

    let _imageView: UIImageView = Ext.image(.warning, width: 36, height: 36)
    let messageLabel: UILabel = .common(size: 14, weight: .semibold, color: UIColor(hexCode: "BCC7DD"))

    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 12
        [_imageView, messageLabel]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
