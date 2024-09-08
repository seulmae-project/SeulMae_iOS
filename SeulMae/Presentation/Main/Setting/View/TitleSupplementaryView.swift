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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.adjustsFontForContentSizeCategory = true
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
