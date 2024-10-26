//
//  OutlineSupplementaryView.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

class OutlineSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "outline-supplementary-reuse-identifier"

    let titleLabel: UILabel = Ext.config(font: .pretendard(size: 18, weight: .semibold))
    let descriptionLabel: UILabel = Ext.config(font: .pretendard(size: 12, weight: .regular), color: UIColor(hexCode: "BDBEC0"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 4.0
        let views = [titleLabel, descriptionLabel]
        views.forEach(contentStack.addArrangedSubview(_:))

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
}


