//
//  SearchBarView.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit

final class SearchBarView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .searchBarIcon
        return imageView
    }()
    
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "근무지 검색"
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(hexCode: "BCC7DD").cgColor

        let contentStack = UIStackView()
        contentStack.alignment = .center
        contentStack.spacing = 8.0
        [textField, imageView]
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

            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
