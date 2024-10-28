//
//  TitleSupplementaryView.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    
    let label = UILabel()
    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
        
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
