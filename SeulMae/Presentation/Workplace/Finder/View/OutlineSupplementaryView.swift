//
//  OutlineSupplementaryView.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

class OutlineSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "outline-supplementary-reuse-identifier"
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let separatorView = UIView()
    private let stack = UIStackView()
    var showsSeparator = true {
        didSet {
            separatorView.isHidden = !showsSeparator
            let spacing: CGFloat = showsSeparator ? 40 : 0
            stack.setCustomSpacing(spacing, after: separatorView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        separatorView.backgroundColor = .signinSeparator
        
        stack.axis = .vertical
        stack.spacing = 4.0
        let views = [separatorView, titleLabel, descriptionLabel]
        views.forEach(stack.addArrangedSubview(_:))
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


