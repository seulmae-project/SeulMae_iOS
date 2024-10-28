//
//  TextInputFormView.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

class TextInputFormView: UIView {
    let label: UILabel = .common(size: 14, weight: .semibold)
    let textField: UITextField = .common(placeholder: "", size: 16, weight: .regular)
    let validationResultsLabel: UILabel = .footnote()

    convenience init(title: String, placeholder: String) {
        self.init(frame: .zero)
        label.text = title
        textField.ext.placeholder(placeholder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelContainer = UIView()
        labelContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        [labelContainer, textField, validationResultsLabel]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let spacing = CGFloat(8.0)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: spacing),
            label.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            label.topAnchor.constraint(equalTo: labelContainer.topAnchor),
            label.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor),

            textField.heightAnchor.constraint(equalToConstant: 48),

            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
