//
//  SearchBarView.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit

class SearchBarView: UIView {

    private let _imageView: UIImageView = Ext.image(.searchBarIcon, width: 24, height: 24)
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "근무지 검색"
        return textfield
    }()
    
    convenience init() {
        self.init(frame: .zero)

        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(hexCode: "BCC7DD").cgColor

        let contentStack = UIStackView()
        contentStack.alignment = .center
        contentStack.spacing = 8.0
        [textField, _imageView]
            .forEach(contentStack.addArrangedSubview(_:))
        let margins = NSDirectionalEdgeInsets(
            top: 0, leading: 16, bottom: 0, trailing: 16)
        contentStack.directionalLayoutMargins = margins
        contentStack.isLayoutMarginsRelativeArrangement = true

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 48)
    }
}
